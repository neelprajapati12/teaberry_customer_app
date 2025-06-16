import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
import 'package:teaberryapp_project/forgotpassword_screen.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/shared_pref.dart';

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

  String? selectedRole;
  String? selectedStore;

  final roles = ['Customer', 'Delivery Boy'];
  final stores = ['Store 1', 'Store 2'];

  // First, fix the imports at the top of the file
  // Remove or comment out: import 'package:http/http.dart' as http;

  Future<void> signup() async {
    try {
      // Input validation
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          mobileController.text.isEmpty ||
          passwordController.text.isEmpty) {
        throw Exception('Please fill all required fields');
      }

      final userData = jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'mobile': mobileController.text,
        'password': passwordController.text,
        'role': "ROLE_CUSTOMER",
        'storeId': 1,
      });

      // Create form data with userData part
      final formData = FormData.fromMap({
        'userData': MultipartFile.fromString(
          userData,
          contentType: MediaType('application', 'json'),
        ),
      });

      // Create Dio instance with base options
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstant.baseUrl,
          validateStatus: (status) => status! < 500,
        ),
      );

      // Print request details for debugging
      print('Request URL: ${ApiConstant.baseUrl}/auth/signup');
      print('Request Body: ${formData.fields}');

      // Make API request
      final response = await dio.post(
        '/auth/signup',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            // 'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Signup successful!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Yellow Header with Logo and Text
          Container(
            color: Appcolors.yellow,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/iamges/removebckclr.png',
                  height: 110,
                  width: 110,
                ),
                SizedBox(height: 15),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please sign up to get started',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),

          // Form Body
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
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
                    CustomTextFormField(
                      controller: nameController,
                      hintText: "Adam Doe",
                    ),
                    SizedBox(height: 20),
                    Text("MOBILE NO"),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: mobileController,
                      hintText: "+91 88888 34213",
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),
                    Text("EMAIL"),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "adam.doe@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    Text("NEAREST STORE"),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        hint: Text("Please select"),
                        value: selectedStore,
                        items:
                            stores
                                .map(
                                  (store) => DropdownMenuItem(
                                    value: store,
                                    child: Text(store),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => selectedStore = val),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("ADDRESS"),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: addressController,
                      hintText: "27-A, Aparna apartments, Gandhinagar...",
                    ),
                    SizedBox(height: 20),
                    Text("PASSWORD"),
                    SizedBox(height: 5),
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
                    SizedBox(height: 20),
                    Text("RE-TYPE PASSWORD"),
                    SizedBox(height: 5),
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
                    SizedBox(height: 30),
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
                    SizedBox(height: 20),
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
                    vSize(20),
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
