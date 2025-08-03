import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/verification_screen.dart';
// import 'package:teaberryapp_project/customer_screens/verification_screen.dart';
// import 'package:teaberryapp_project/verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  forgotpassword() async {
    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/auth/password/forgot');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"email": emailController.text});

      final response = await http.post(url, headers: headers, body: body);

      Navigator.of(context).pop(); // Hide loading dialog

      if (response.statusCode == 200) {
        // Check if response is JSON or plain text
        final contentType = response.headers['content-type'] ?? '';
        if (contentType.contains('application/json')) {
          final data = jsonDecode(response.body);
          print("Parsed JSON response: $data");
        } else {
          print("Plain response: ${response.body}");
        }

        showAppToast("OTP sent to your email successfully");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VerificationScreen(email: emailController.text),
          ),
        );
      } else {
        print("SignUp failed: ${response.statusCode}");
        print("Response body: ${response.body}");
        showErrorToast("Invalid email address. Please try again.");
      }
    } catch (e) {
      // Navigator.of(context).pop(); // Ensure dialog is dismissed on error
      print("Signup exception: $e");
      showErrorToast("Something went wrong. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Appcolors.yellow,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 6),
              vertical: ResponsiveSize.height(context, 5),
            ),
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
                          // size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                // Image.asset(
                //   'assets/iamges/teaberry_logo.jpg',
                //   height: 80,
                //   width: 80,
                // ),
                SizedBox(height: ResponsiveSize.height(context, 2)),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 6),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                Text(
                  'Please sign in to your existing account',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 4),
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: ResponsiveSize.height(context, 28),
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
                    SizedBox(height: ResponsiveSize.height(context, 2.5)),
                    Text(
                      "EMAIL",
                      style: TextStyle(
                        fontSize: ResponsiveSize.font(context, 3.5),
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "example@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 3.5)),
                    ElevatedButton(
                      onPressed: () {
                        forgotpassword();
                      },
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
                        "SEND CODE",
                        style: TextStyle(
                          fontSize: ResponsiveSize.font(context, 4),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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
