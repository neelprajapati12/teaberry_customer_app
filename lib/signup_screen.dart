import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
import 'package:teaberryapp_project/customer_screens/signup_otp_verification.dart';
import 'package:teaberryapp_project/forgotpassword_screen.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/shared_pref.dart';
import 'constants/responsivesize.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  String? selectedRole;
  String? selectedStore;

  final roles = ['Customer', 'Delivery Boy'];
  final stores = ['Store 1', 'Store 2'];

  File? _photoFile;
  final _picker = ImagePicker();

  Future<void> pickImage(Function(File) onPicked) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

  Future<void> _uploadImage(Function(File) onPicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png', 'jpg'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      onPicked(file);

      // Optional: Save locally if needed
      // await SharedPreferencesHelper.setUserImage(file);
      showAppToast("Image Uploaded Successfully!");
      // Fluttertoast.showToast(
      //   msg: "Image Selected Successfully!",
      //   backgroundColor: Color(0xffFFDFDF),
      //   textColor: Appcolors.red,
      // );
    }
  }

  // First, fix the imports at the top of the file
  // Remove or comment out: import 'package:http/http.dart' as http;

  Future<void> signup() async {
    try {
      // Input validation
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          mobileController.text.isEmpty ||
          passwordController.text.isEmpty ||
          selectedStore == null) {
        throw Exception(
          'Please fill all required fields including store selection',
        );
      }

      final selectedStoreId = storeIdMap[selectedStore];
      if (selectedStoreId == null) {
        throw Exception('Invalid store selection');
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 1. Core userData payload
      final Map<String, dynamic> userData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'mobile': mobileController.text.trim(),
        'password': passwordController.text,
        'address': addressController.text.trim(),
        'role': 'ROLE_CUSTOMER',
        'storeId': selectedStoreId,
      };

      // 2. Conditionally add referral info
      final String refText = referralCodeController.text.trim();
      if (refText.isNotEmpty) {
        if (RegExp(r'^\d+$').hasMatch(refText)) {
          // all digits → delivery boy ID
          userData['referredByDeliveryBoyId'] = int.parse(refText);
        } else {
          // non‐digit → referral code
          userData['referralCode'] = refText;
        }
      }

      // 3. Build FormData (photo is still optional)
      final formData = FormData.fromMap({
        'userData': MultipartFile.fromString(
          jsonEncode(userData),
          contentType: MediaType('application', 'json'),
        ),
        if (_photoFile != null)
          'photo': await MultipartFile.fromFile(
            _photoFile!.path,
            filename: _photoFile!.path.split('/').last,
            contentType: MediaType(
              'image',
              _photoFile!.path.toLowerCase().endsWith('.png') ? 'png' : 'jpeg',
            ),
          ),
      });

      // 4. Send the request as before...

      final dio = Dio();
      dio.options.baseUrl = ApiConstant.baseUrl;

      print('Request URL: ${ApiConstant.baseUrl}/auth/signup');
      print('Request Fields: ${formData.fields}');
      if (_photoFile != null) {
        print('Photo being sent: ${_photoFile!.path}');
      }

      final response = await dio.post(
        '/auth/signup',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      // Hide loading dialog
      Navigator.of(context).pop();

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferencesHelper.setIsLoggedIn(status: true);
        SharedPreferencesHelper.setcustomeraddress(
          address: addressController.text,
        );
        SharedPreferencesHelper.setcustomerpassword(
          password: passwordController.text,
        );
        showAppToast(response.data['message'] ?? 'Signup successful');
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Signup successful!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => SignupOtpVerification(email: emailController.text),
          ),
        );
      } else {
        final errorMessage = response.data['message'] ?? 'Signup failed';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      Navigator.of(context).pop(); // Hide loading dialog
      String errorMessage = 'An error occurred';

      if (e.response != null) {
        print('Error Response: ${e.response?.data}');
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timed out';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading dialog
      showErrorToast(e.toString());
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  List<dynamic> data = [];
  List<String> officialstores = [];
  bool isLoadingStores = false;

  Map<String, int> storeIdMap = {}; // To store name-to-id mapping

  // Update the getstoresdata() function to store store IDs
  Future<void> getstoresdata() async {
    setState(() {
      isLoadingStores = true;
    });

    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/users/2/complete-details');
      print('Fetching stores from: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('Response body: ${response.body}');

        if (decoded['stores'] != null) {
          setState(() {
            data = decoded['stores'];
            // Clear existing data
            officialstores.clear();
            storeIdMap.clear();

            // Populate both the names list and ID map
            for (var store in data) {
              if (store['name'] != null && store['id'] != null) {
                officialstores.add(store['name'].toString());
                storeIdMap[store['name'].toString()] = store['id'];
              }
            }

            stores.clear();
            stores.addAll(officialstores);

            print('Successfully fetched ${officialstores.length} stores');
            print('Store names and IDs: $storeIdMap');
          });
        } else {
          throw Exception('No stores found in response');
        }
      } else {
        throw Exception('Failed to load stores: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stores: $e');
      showAppToast('Failed to load stores. Please try again.');
    } finally {
      setState(() {
        isLoadingStores = false;
      });
    }
  }
  // Update the dropdown widget in the build method to use the fetched stores

  @override
  void initState() {
    super.initState();
    // Initialize any necessary data or state
    getstoresdata();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Appcolors.yellow,
        leading: Padding(
          padding: EdgeInsets.only(left: ResponsiveSize.width(context, 4)),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: ResponsiveSize.width(context, 7),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                // size: ResponsiveSize.font(context, ,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Yellow Header with Logo and Text
          Container(
            color: Appcolors.yellow,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 6),
              // vertical: ResponsiveSize.height(context, 5),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/iamges/logo.png',
                  fit: BoxFit.fill,
                  height: ResponsiveSize.height(context, 18),
                  width: ResponsiveSize.width(context, 45),
                ),
                SizedBox(height: ResponsiveSize.height(context, 2)),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 7.5),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                Text(
                  'Please sign up to get started',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 4),
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Form Body
          Positioned(
            top: ResponsiveSize.height(context, 32),
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveSize.width(context, 8)),
                  topRight: Radius.circular(ResponsiveSize.width(context, 8)),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 6),
                  vertical: ResponsiveSize.height(context, 2.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("NAME"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    CustomTextFormField(
                      controller: nameController,
                      hintText: "Adam Doe",
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("MOBILE NO"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    CustomTextFormField(
                      controller: mobileController,
                      hintText: "+91 88888 34213",
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("EMAIL"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "adam.doe@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("NEAREST STORE"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.width(context, 2),
                        ),
                      ),
                      child:
                          isLoadingStores
                              ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveSize.width(context, 2),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.width(
                                      context,
                                      4,
                                    ),
                                  ),
                                ),
                                hint: const Text("Select nearest store"),
                                value: selectedStore,
                                items:
                                    officialstores
                                        .map(
                                          (store) => DropdownMenuItem(
                                            value: store,
                                            child: Text(store),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (val) =>
                                        setState(() => selectedStore = val),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a store';
                                  }
                                  return null;
                                },
                              ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("ADDRESS"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    CustomTextFormField(
                      controller: addressController,
                      hintText: "27-A, Aparna apartments, Gandhinagar...",
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("PASSWORD"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("RE-TYPE PASSWORD"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _hideConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Re-type Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hideConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    _hideConfirmPassword =
                                        !_hideConfirmPassword,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("REFERRAL CODE or REFERRAL ID(Optional)"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    CustomTextFormField(
                      controller: referralCodeController,
                      hintText: "Enter referral code or referral id(if any)",
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    // Upload PHOTO
                    imageUploader(
                      "UPLOAD PHOTO(Optional)",
                      _photoFile,
                      () => _uploadImage((f) => setState(() => _photoFile = f)),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 3)),
                    ElevatedButton(
                      onPressed: () async {
                        print("Sign Up button pressed");
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match!')),
                          );
                          return;
                        }
                        await signup();
                      },
                      // Add signup logic here
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "LOG IN",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    vSize(ResponsiveSize.height(context, 2)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageUploader(String label, File? file, VoidCallback onPick) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  file != null ? "Selected" : "No file chosen",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: onPick,
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("UPLOAD", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
