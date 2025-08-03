import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';

class ConfirmationScreen extends StatefulWidget {
  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  // @override
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
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
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🎉 Congratulations!',
                style: TextStyle(
                  fontSize: ResponsiveSize.font(context, 8),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveSize.height(context, 2.5)),
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
                padding: EdgeInsets.all(ResponsiveSize.width(context, 8)),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: ResponsiveSize.width(context, 20),
                  color: Color(0xFF28C76F),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 3.5)),
              Text(
                'Your order has been successfully placed!',
                style: TextStyle(
                  fontSize: ResponsiveSize.font(context, 5),
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
