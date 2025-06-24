import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import 'package:teaberryapp_project/constants/app_colors.dart';

void main() {
  runApp(MaterialApp(
    home: EmailVerificationScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  TextEditingController _otpController = TextEditingController();
  int _timerSeconds = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    _timerSeconds = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Appcolors.yellow,
            width: double.infinity,
            padding: EdgeInsets.only(top: 60, bottom: 30),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'We have sent a code to your email',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  'example@gmail.com',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("CODE", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  _timerSeconds > 0
                      ? "Resend in $_timerSeconds sec"
                      : "Resend Code",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: PinCodeTextField(
              length: 6,
              controller: _otpController,
              appContext: context,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeColor: Colors.grey,
                selectedColor: Colors.grey,
                inactiveColor: Colors.grey,
              ),
              onChanged: (value) {},
              enableActiveFill: true,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                print("Entered OTP: ${_otpController.text}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.green,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("VERIFY",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}