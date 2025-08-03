import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
import 'package:teaberryapp_project/resetpassword.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  VerificationScreen({required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController otpController = TextEditingController();
  String currentText = "";
  String storedOTP = "";
  Timer? _timer;
  int _countdownSeconds = 60;
  bool _timerRunning = false;
  bool isOtpSent = false;
  bool showResend = false;

  Future<void> resendotp() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final url = Uri.parse('${ApiConstant.baseUrl}/auth/password/forgot');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"email": widget.email});

      final response = await http.post(url, headers: headers, body: body);

      // Hide loading dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        showAppToast("OTP sent to your email successfully");
      } else {
        print("Resend OTP failed: ${response.statusCode}");
        print("Response body: ${response.body}");
        showErrorToast("Failed to resend OTP. Please try again.");
      }
    } catch (e) {
      // Hide loading dialog
      Navigator.of(context).pop();
      print("Resend OTP exception: $e");
      showErrorToast("Something went wrong. Please try again.");
    }
  }

  @override
  void codeUpdated() {
    setState(() {
      // Removed undefined variable 'code' assignment
      // If needed, define 'code' or replace this line with appropriate logic
    });
  }

  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    SmsAutoFill().unregisterListener();
    otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _timerRunning = true;
      _countdownSeconds = 60;
      showResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _timerRunning = false;
          showResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Yellow Header with Back Button
          Container(
            color: Color(0xffEED067),
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
                  'Verification',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 7.5),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                Text(
                  'We have sent a code to your email',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 4),
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                Text(
                  widget.email,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // White Container with Verification Form
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CODE',
                          style: TextStyle(
                            fontSize: ResponsiveSize.font(context, 3.5),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add resend logic
                          },
                          child: Text(
                            'Resend in ${_countdownSeconds}s',
                            style: TextStyle(
                              fontSize: ResponsiveSize.font(context, 3.5),
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: otpController,
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                          storedOTP = value;
                        });
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.width(context, 2),
                        ),
                        fieldHeight: ResponsiveSize.height(context, 7),
                        fieldWidth: ResponsiveSize.width(context, 12),
                        activeFillColor: Colors.grey[200],
                        inactiveFillColor: Colors.grey[200],
                        selectedFillColor: Colors.grey[200],
                        activeColor: Appcolors.green,
                        inactiveColor: Colors.grey[300],
                        selectedColor: Appcolors.green,
                      ),
                      cursorColor: Appcolors.green,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 3.5)),

                    // Add Resend OTP section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        if (!showResend) ...[
                          Text(
                            '${_countdownSeconds}s',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ] else
                          GestureDetector(
                            onTap: () async {
                              if (showResend) {
                                // Only allow resend when timer has expired
                                setState(() {
                                  isOtpSent = true;
                                });

                                // Call the resendotp function
                                await resendotp();

                                // Restart the timer
                                startTimer();

                                setState(() {
                                  isOtpSent = false;
                                });
                              }
                            },
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    showResend
                                        ? Appcolors.green
                                        : Colors.grey, // Grey when disabled
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 6)),
                    ElevatedButton(
                      onPressed: () {
                        if (currentText.length == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ResetpasswordScreen(
                                    verificationOTP: storedOTP, // Pass the OTP
                                    email:
                                        widget
                                            .email, // Pass the email as well if needed
                                  ),
                            ),
                          );
                        } else {
                          showErrorToast("Please enter complete OTP");
                        }
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
                        "VERIFY",
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
