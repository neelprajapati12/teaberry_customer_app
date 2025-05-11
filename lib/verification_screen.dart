import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
// import 'package:teaberryapp_project/bottom_navbar.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
// import 'package:teaberryapp_project/home_screen.dart';
// import 'package:teaberryapp_project/resturantview_screen.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController otpController = TextEditingController();
  String currentText = "";
  Timer? _timer;
  int _countdownSeconds = 60;
  bool _timerRunning = false;
  bool isOtpSent = false;
  bool showResend = false;

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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Yellow Header with Back Button
          Container(
            color: Color(0xffEED067),
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
                // Image.asset(
                //   'assets/iamges/teaberry_logo.jpg',
                //   height: 80,
                //   width: 80,
                // ),
                SizedBox(height: 15),
                Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We have sent a code to your email',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                vSize(5),
                Text(
                  'example@gmail.com',
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
            top: MediaQuery.of(context).size.height * 0.28,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CODE',
                          style: TextStyle(
                            fontSize: 14,
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
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: otpController,
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 60,
                        fieldWidth: 50,
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
                    SizedBox(height: 16),

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
                              setState(() {
                                isOtpSent = true;
                              });

                              // Add your resend OTP API call here
                              // await apiValue.requestOTP(mobileNumber);

                              startTimer();

                              setState(() {
                                isOtpSent = false;
                              });
                              showAppToast("OTP sent successfully!");
                              // Fluttertoast.showToast(
                              //   msg: "OTP sent successfully!",
                              //   backgroundColor: Colors.grey,
                              // );
                            },
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 14,
                                color: Appcolors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (currentText.length == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavbarCustomer(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "VERIFY",
                        style: TextStyle(
                          fontSize: 16,
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
