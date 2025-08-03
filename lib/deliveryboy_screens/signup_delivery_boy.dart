import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import '../constants/api_constant.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';

class SignupDeliveryBoy extends StatefulWidget {
  @override
  _SignupDeliveryBoyState createState() => _SignupDeliveryBoyState();
}

class _SignupDeliveryBoyState extends State<SignupDeliveryBoy> {
  bool _hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final referralcontroller = TextEditingController();

  String? selectedStore;
  final stores = ['Store 1', 'Store 2'];

  File? _photoFile;
  File? _aadhaarFront;
  File? _aadhaarBack;

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

  Future<void> registerDeliveryBoy() async {
    if (!_formKey.currentState!.validate()) return;

    if (_photoFile == null || _aadhaarFront == null || _aadhaarBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload photo, Aadhaar front and back")),
      );
      return;
    }

    // Get the store ID for the selected store
    final selectedStoreId = storeIdMap[selectedStore];
    if (selectedStoreId == null) {
      showErrorToast("Invalid store selection");
      return;
    }

    final dio = Dio();

    final userData = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": mobileController.text.trim(),
      "password": passwordController.text.trim(),
      "role": "ROLE_DELIVERY_BOY",
      "storeId": selectedStoreId, // Use the correct store ID from the map
      // "referredByDeliveryBoyId":
      //     referralcontroller.text.trim().isNotEmpty
      //         ? referralcontroller.text.trim()
      //         : null,
    };

    try {
      print('Registering with store ID: $selectedStoreId'); // Debug print

      final formData = FormData.fromMap({
        'userData': MultipartFile.fromString(
          json.encode(userData),
          contentType: MediaType("application", "json"),
        ),
        // ...rest of your formData configuration

        // ...rest of your registration code
        'photo': await MultipartFile.fromFile(
          _photoFile!.path,
          filename: _photoFile!.path.split('/').last,
        ),
        'aadharFront': await MultipartFile.fromFile(
          _aadhaarFront!.path,
          filename: _aadhaarFront!.path.split('/').last,
        ),
        'aadharBack': await MultipartFile.fromFile(
          _aadhaarBack!.path,
          filename: _aadhaarBack!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        "${ApiConstant.baseUrl}/auth/signup",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        showAppToast(response.data['message'] ?? "Registered successfully");
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text("Registered successfully")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        showErrorToast(
          "Registration failed: ${response.data['error'] ?? response.statusMessage}",
        );
      }
    } catch (e) {
      print("Dio error: $e");
      showErrorToast("Something went wrong: $e");
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
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
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
            Positioned(
              top: ResponsiveSize.height(context, 32),
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 6),
                  vertical: ResponsiveSize.height(context, 2.5),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(ResponsiveSize.width(context, 8)),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveSize.height(context, 2)),
                      buildTextField(
                        "NAME",
                        nameController,
                        hinttext: "Adam Doe",
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                      buildTextField(
                        "MOBILE",
                        mobileController,
                        type: TextInputType.phone,
                        hinttext: "+91 88888 34213",
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                      buildTextField(
                        "EMAIL",
                        emailController,
                        type: TextInputType.emailAddress,
                        hinttext: "example@gmail.com",
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
                      buildTextField(
                        "ADDRESS",
                        addressController,
                        hinttext: "27-A, Aparna apartments, Gandhinagar...",
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
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.width(context, 2),
                            ),
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
                      imageUploader(
                        "UPLOAD PHOTO",
                        _photoFile,
                        () =>
                            _uploadImage((f) => setState(() => _photoFile = f)),
                      ),
                      imageUploader(
                        "AADHAAR FRONT",
                        _aadhaarFront,
                        () => _uploadImage(
                          (f) => setState(() => _aadhaarFront = f),
                        ),
                      ),
                      imageUploader(
                        "AADHAAR BACK",
                        _aadhaarBack,
                        () => _uploadImage(
                          (f) => setState(() => _aadhaarBack = f),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 2)),
                      ElevatedButton(
                        onPressed: registerDeliveryBoy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.green,
                          minimumSize: Size(
                            double.infinity,
                            ResponsiveSize.height(context, 6),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.width(context, 2),
                            ),
                          ),
                        ),
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveSize.font(context, 4),
                          ),
                        ),
                      ),
                      vSize(ResponsiveSize.height(context, 2.5)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool isPassword = false,
    required String hinttext,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: type,
            obscureText: isPassword,
            validator: (val) => val == null || val.isEmpty ? "Required" : null,
            decoration: InputDecoration(
              hintText: hinttext,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget storeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: selectedStore,
        hint: Text("Select Store"),
        items:
            stores
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
        onChanged: (val) => setState(() => selectedStore = val),
        validator: (val) => val == null ? "Select a store" : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
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
