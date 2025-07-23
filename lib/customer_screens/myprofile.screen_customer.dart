import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import 'package:teaberryapp_project/models/customer_model.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class ProfileScreenCustomer extends StatefulWidget {
  const ProfileScreenCustomer({super.key});

  @override
  State<ProfileScreenCustomer> createState() => _ProfileScreenCustomerState();
}

class _ProfileScreenCustomerState extends State<ProfileScreenCustomer> {
  bool _isEditing = true;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  String? selectedStore;

  // final TextEditingController nameController = TextEditingController(
  //   text: "Adam Doe",
  // );
  // final TextEditingController mobileController = TextEditingController(
  //   text: "+91 88888 34213",
  // );
  // final TextEditingController emailController = TextEditingController(
  //   text: "adam.doe@gmail.com",
  // );
  final TextEditingController addressController = TextEditingController(
    text: "27-A, Aparna apartments, Gurudev..",
  );
  // final TextEditingController passwordController = TextEditingController(
  //   text: "",
  // );
  // final TextEditingController confirmPasswordController = TextEditingController(
  //   text: "",
  // );

  final stores = ['Store 1', 'Store 2'];

  bool isLoading = true;
  String error = '';

  List<CustomerModel> profile = [];

  // 1. Initialize controllers with empty text
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController storeController = TextEditingController();
  final TextEditingController referralcodecontroller = TextEditingController();

  // ...existing code...

  Future<void> fetchProfile() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      print('Fetching products from: ${ApiConstant.baseUrl}/auth/profile');
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
        },
      );

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Profile Data Fetched Successfully: $jsonResponse');
        final customer = CustomerModel.fromJson(jsonResponse);

        setState(() {
          profile = [customer];
          // 2. Set controller values from API data
          nameController.text = customer.name ?? '';
          mobileController.text = customer.mobile ?? '';
          emailController.text = customer.email ?? '';
          storeController.text = "Store ${customer.store!.id.toString()}" ?? '';
          referralcodecontroller.text = customer.referralCode ?? '';
          // addressController.text = customer.address ?? '';
          isLoading = false;
          print(profile);
        });
      } else {
        setState(() {
          error = 'Failed to FETCH Profile: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile(
    String name,
    String email,
    String mobileno,
    String address,
  ) async {
    try {
      // Input validation
      // if (nameController.text.isEmpty ||
      //     emailController.text.isEmpty ||
      //     mobileController.text.isEmpty) {
      //   showAppToast('Please fill all required fields');
      //   return;
      // }
      print(name);
      print(email);
      print(mobileno);
      print(address);

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final userData = jsonEncode({
        'name': name,
        'email': email,
        'mobile': mobileno,
        // 'password': passwordController.text,
        'address': address,
      });

      final formData = FormData.fromMap({
        'userData': MultipartFile.fromString(
          userData,
          contentType: MediaType('application', 'json'),
        ),
      });

      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstant.baseUrl,
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Request URL: ${ApiConstant.baseUrl}/auth/update-profile');
      print('Request Body: ${formData.fields}');

      final response = await dio.put(
        '/auth/update-profile',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization':
                'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
          },
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      Navigator.of(context).pop(); // Hide loading dialog

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferencesHelper.setIsLoggedIn(status: true);
        SharedPreferencesHelper.setcustomeraddress(
          address: addressController.text,
        );
        // SharedPreferencesHelper.setcustomerpassword(
        //   password: passwordController.text,
        // );
        showAppToast(response.data['message'] ?? 'Profile Update successful');
      } else {
        final errorMessage =
            response.data['message'] ?? 'Profile update failed';
        showAppToast(errorMessage);
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return profile.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Appcolors.yellow,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Appcolors.white),
                onPressed: () {
                  // Handle notification icon press
                  SharedPreferencesHelper.setIsLoggedIn(status: false);
                  SharedPreferencesHelper.clearRole();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              // Yellow Header with Back Button and Profile
              Container(
                color: Appcolors.yellow,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: IconButton(
                    //     icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
                    //     onPressed: () => Navigator.pop(context),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'My Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You may edit your details here.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // White Container with Form
              Positioned(
                top: MediaQuery.of(context).size.height * 0.26,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vSize(10),
                        Text("NAME"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: nameController,
                          enabled: _isEditing,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "Adam Doe",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("MOBILE NO"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: mobileController,
                          enabled: false,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "+91 88888 34213",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            // suffixIcon: Icon(
                            //   Icons.edit,
                            //   size: 16,
                            //   color: Colors.grey,
                            // ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("EMAIL"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: emailController,
                          enabled: false,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "adam.doe@gmail.com",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            // suffixIcon: Icon(
                            //   Icons.edit,
                            //   size: 16,
                            //   color: Colors.grey,
                            // ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("NEAREST STORE"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: storeController,
                          enabled: false,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "27-A, Aparna apartments, Gurudev..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            // suffixIcon: Icon(
                            //   Icons.edit,
                            //   size: 16,
                            //   color: Colors.grey,
                            // ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("ADDRESS"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: addressController,
                          enabled: _isEditing,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "27-A, Aparna apartments, Gurudev..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            // suffixIcon: Icon(
                            //   Icons.edit,
                            //   size: 16,
                            //   color: Colors.grey,
                            // ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("REFERRAL CODE"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: referralcodecontroller,
                          readOnly: true,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            // hintText: "27-A, Aparna apartments, Gurudev..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              // Changed from GestureDetector to IconButton
                              onPressed: () async {
                                print("Share button pressed");
                                final String referralCode =
                                    referralcodecontroller.text;
                                if (referralCode.isNotEmpty) {
                                  try {
                                    await Share.share(
                                      'Hey! Use my referral code "$referralCode" to get exciting offers on TeaBerry App!',
                                      subject: 'TeaBerry Referral Code',
                                    );
                                  } catch (e) {
                                    print('Error sharing: $e');
                                    showAppToast('Error sharing referral code');
                                  }
                                } else {
                                  showAppToast(
                                    'No referral code available to share',
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.share,
                                size: 28,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            updateProfile(
                              nameController.text,
                              emailController.text,
                              mobileController.text,
                              addressController.text,
                            );
                            // setState(() {
                            //   if (_isEditing) {
                            //     // Save changes logic here
                            //   }
                            //   _isEditing = !_isEditing;
                            // });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.green,
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "UPDATE",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        vSize(100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}


// Text("PASSWORD"),
                    // SizedBox(height: 5),
                    // TextFormField(
                    //   controller: passwordController,
                    //   enabled: _isEditing,
                    //   cursorColor: Colors.black,
                    //   obscureText: _hidePassword,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.grey[200],
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     suffixIcon: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         IconButton(
                    //           icon: Icon(
                    //             _hidePassword
                    //                 ? Icons.visibility_off
                    //                 : Icons.visibility,
                    //             size: 16,
                    //           ),
                    //           onPressed:
                    //               () => setState(
                    //                 () => _hidePassword = !_hidePassword,
                    //               ),
                    //         ),
                    //         // Icon(Icons.edit, size: 16, color: Colors.grey),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    
                    // SizedBox(height: 20),
                    // Text("RE-TYPE PASSWORD"),
                    // SizedBox(height: 5),
                    // TextFormField(
                    //   controller: confirmPasswordController,
                    //   enabled: _isEditing,
                    //   cursorColor: Colors.black,
                    //   obscureText: _hideConfirmPassword,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.grey[200],
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     suffixIcon: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         IconButton(
                    //           icon: Icon(
                    //             _hideConfirmPassword
                    //                 ? Icons.visibility_off
                    //                 : Icons.visibility,
                    //             size: 16,
                    //           ),
                    //           onPressed:
                    //               () => setState(
                    //                 () =>
                    //                     _hideConfirmPassword =
                    //                         !_hideConfirmPassword,
                    //               ),
                    //         ),
                    //         // Icon(Icons.edit, size: 16, color: Colors.grey),
                    //       ],
                    //     ),
                    //   ),
                    // ),


// Future<void> updateProfile() async {
  //   print("Into update profile function");
  //   try {
  //     setState(() {
  //       isLoading = true;
  //       error = '';
  //     });

  //     final body = {
  //       "name": nameController.text,
  //       "mobile": mobileController.text,
  //       "email": emailController.text,
  //       "address": addressController.text,
  //       // Add other fields as needed
  //     };

  //     final response = await http.put(
  //       Uri.parse('${ApiConstant.baseUrl}/auth/update-profile'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
  //       },
  //       body: json.encode(body),
  //     );

  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       // Optionally, refresh profile data
  //       fetchProfile();
  //       showAppToast('Profile updated successfully!');
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text('Profile updated successfully!')),
  //       // );
  //     } else {
  //       setState(() {
  //         error = 'Failed to update profile: ${response.statusCode}';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       error = 'Error: $e';
  //     });
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }