import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';

class ConfirmationScreen extends StatefulWidget {
  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  // @override
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbarCustomer()),
      );
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEED067),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🎉 Congratulations!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Changed here
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(30),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: Color(0xFF28C76F),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Your order has been successfully placed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
