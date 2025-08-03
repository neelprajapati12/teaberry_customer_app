import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';

class ResetpasswordScreen extends StatefulWidget {
  final String? email;
  final String? verificationOTP;
  const ResetpasswordScreen({
    required this.email,
    required this.verificationOTP,
    super.key,
  });

  @override
  State<ResetpasswordScreen> createState() => _ResetpasswordScreenState();
}

class _ResetpasswordScreenState extends State<ResetpasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool _hidePassword = false;

  resetPassword() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final url = Uri.parse('${ApiConstant.baseUrl}/auth/password/reset');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "email": widget.email,
        "otp": widget.verificationOTP,
        "newPassword": passwordController.text,
      });

      final response = await http.post(url, headers: headers, body: body);

      Navigator.of(context).pop(); // Hide loading dialog

      if (response.statusCode == 200) {
        showAppToast("Password reset successful");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      } else {
        print("Reset password failed: ${response.statusCode}");
        print("Response body: ${response.body}");
        showErrorToast("Failed to reset password. Please try again.");
      }
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading dialog
      print("Reset password exception: $e");
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
                          // size: ResponsiveSize.font(context, 3),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.height(context, 2)),
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 6),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                Text(
                  'Please enter your new password',
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
                      "NEW PASSWORD",
                      style: TextStyle(
                        fontSize: ResponsiveSize.font(context, 3.5),
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    TextFormField(
                      controller: passwordController,
                      obscureText:
                          !_hidePassword, // Changed to !showPassword for correct behavior
                      decoration: InputDecoration(
                        hintText: "Enter New Password",
                        hintStyle: TextStyle(color: Colors.black38),
                        filled: true,
                        fillColor: Colors.grey[200],
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
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
                    SizedBox(height: ResponsiveSize.height(context, 3.5)),
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text.isEmpty) {
                          showErrorToast("Please enter a password");
                          return;
                        }
                        resetPassword();
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
                        "RESET PASSWORD",
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
