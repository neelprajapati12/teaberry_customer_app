import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/deliveryboy_screens/signup_delivery_boy.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import 'package:teaberryapp_project/signup_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String userType = 'Customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Sign Up',
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
                  'Please Choose a role to sign up as',
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
                    vSize(ResponsiveSize.height(context, 2)),
                    RadioListTile<String>(
                      value: 'Customer',
                      groupValue: userType,
                      onChanged: (value) {
                        setState(() {
                          userType = value!;
                        });
                      },
                      title: const Text('Customer'),
                      activeColor: Appcolors.green,
                    ),
                    RadioListTile<String>(
                      value: 'Delivery boy',
                      groupValue: userType,
                      onChanged: (value) {
                        setState(() {
                          userType = value!;
                        });
                      },
                      title: const Text('Delivery boy'),
                      activeColor: Appcolors.green,
                    ),
                    vSize(ResponsiveSize.height(context, 4)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF76A04D), // Green color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.width(context, 2),
                          ),
                        ),
                        minimumSize: Size(
                          double.infinity,
                          ResponsiveSize.height(context, 6),
                        ),
                      ),
                      onPressed: () {
                        if (userType == 'Customer') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupDeliveryBoy(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveSize.font(context, 4),
                        ),
                      ),
                    ),
                    vSize(ResponsiveSize.height(context, 4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: ResponsiveSize.font(context, 3.5),
                          ),
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
                              fontSize: ResponsiveSize.font(context, 3.5),
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
