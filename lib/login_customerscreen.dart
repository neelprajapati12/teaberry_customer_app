import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
// import 'package:teaberryapp_project/bottom_navbar.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
import 'package:teaberryapp_project/customer_screens/selectionscreen.dart';
import 'package:teaberryapp_project/deliveryboy_screens/homepage_deliveryboy.dart';
import 'package:teaberryapp_project/forgotpassword_screen.dart';
import 'package:teaberryapp_project/shared_pref.dart';
import 'package:teaberryapp_project/signup_screen.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool showPassword = false;
  TextEditingController numbercontroller = new TextEditingController();
  TextEditingController password = new TextEditingController();

  login() async {
    // Optional: show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    print("Attempting login with credentials:");
    print("Email/Number: ${numbercontroller.text}");
    print("Password length: ${password.text.length} characters");

    // Check for common issues
    if (numbercontroller.text.isEmpty || password.text.isEmpty) {
      showErrorToast("Email/number and password cannot be empty");
      return;
    }

    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/auth/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "mobile": numbercontroller.text,
        "password": password.text,
      });
      print("Request URL: ${ApiConstant.baseUrl}/auth/login");
      print("Request body: $body");

      final response = await http.post(url, headers: headers, body: body);

      Navigator.of(context).pop(); // Hide loading dialog

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        SharedPreferencesHelper.setIsLoggedIn(status: true);

        // Properly extract role from the roles array
        final List<dynamic> roles = data['roles'];
        final String role = roles.isNotEmpty ? roles[0] : "";

        final String token = data['token'];
        final String Id = data['userId'].toString();

        print("Logged in Successfully as $role");

        if (role == "ROLE_SUPERADMIN") {
          SharedPreferencesHelper.setRole(rolename: role);
          SharedPreferencesHelper.setTokensuperadmin(apiKey: token);
          SharedPreferencesHelper.setIDsuperadmin(id: Id);
          SharedPreferencesHelper.setsuperadminusername(
            username: numbercontroller.text,
          );
          SharedPreferencesHelper.setsuperadminpassword(
            password: password.text,
          );
          print(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavbarCustomer()),
          );
        } else if (role == "ROLE_CUSTOMER") {
          SharedPreferencesHelper.setRole(rolename: role);
          SharedPreferencesHelper.setTokencustomer(apiKey: token);
          SharedPreferencesHelper.setIDcustomer(id: Id);
          SharedPreferencesHelper.setcustomermobno(
            mobno: numbercontroller.text,
          );
          SharedPreferencesHelper.setcustomerpassword(password: password.text);
          print(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavbarCustomer()),
          );
        } else if (role == "ROLE_DELIVERY_BOY") {
          SharedPreferencesHelper.setRole(rolename: role);
          SharedPreferencesHelper.setTokendeliveryboy(apiKey: token);
          SharedPreferencesHelper.setIDdeliveryboy(id: Id);
          SharedPreferencesHelper.setdeliveryboymobno(
            mobno: numbercontroller.text,
          );
          SharedPreferencesHelper.setdeliveryboypassword(
            password: password.text,
          );
          print(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomepageDeliveryboy()),
          );
        }
      } else {
        // Parse the error message from the server response
        final errorData = jsonDecode(response.body);
        String errorMessage = "Login failed";

        // Try to extract a meaningful error message
        if (errorData.containsKey('trace') &&
            errorData['trace'].contains("Invalid email or password")) {
          errorMessage =
              "Invalid email or password. Please check your credentials and try again.";
        } else if (errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData.containsKey('error')) {
          errorMessage = errorData['error'];
        }

        print("Login failed: ${response.body}");
        showErrorToast(errorMessage);
      }
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading dialog
      if (e is SocketException) {
        showErrorToast(
          "Cannot connect to server. Please check your internet connection.",
        );
      } else {
        showErrorToast("Something went wrong. Please try again later.");
      }
      print("Login exception details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(227, 177, 1, 0.6),
      body: Stack(
        children: [
          Container(
            color: Color(0xffEED067), // Yellow background color
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 6), // 6% of width
              vertical: ResponsiveSize.height(context, 5), // 5% of height
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/iamges/logo.png',
                  fit: BoxFit.fill,
                  height: ResponsiveSize.height(context, 18), // 18% of height
                  width: ResponsiveSize.width(context, 45), // 45% of width
                ),
                vSize(ResponsiveSize.height(context, 2)),
                Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(
                      context,
                      7.5,
                    ), // 7.5% of width
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                vSize(ResponsiveSize.height(context, 1)),
                Text(
                  'Please sign in to your existing account',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 4), // 4% of width
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: ResponsiveSize.height(context, 37), // 37% of height
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 6), // 6% of width
                vertical: ResponsiveSize.height(context, 2.5), // 2.5% of height
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveSize.width(context, 8)),
                  topRight: Radius.circular(ResponsiveSize.width(context, 8)),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text(
                      "Mobile Number",
                      style: TextStyle(
                        fontSize: ResponsiveSize.font(context, 3.5),
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    CustomTextFormField(
                      controller: numbercontroller,
                      hintText: "9888888888",
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Text("PASSWORD"),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    TextFormField(
                      controller: password,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.black38),
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
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter valid password";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                            Text("Remember me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                          0xFF76A04D,
                        ), // Green color from design
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        login();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavbarCustomer(),
                        //   ),
                        // );
                      },
                      child: Text(
                        "LOG IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoleSelectionScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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
