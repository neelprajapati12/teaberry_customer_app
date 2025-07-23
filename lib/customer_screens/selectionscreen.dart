import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color.fromRGBO(227, 177, 1, 0.6),
      body: Stack(
        children: [
          Container(
            color: Color(0xffEED067), // Yellow background color
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ), // Increased vertical padding
            child: Column(
              children: [
                Image.asset(
                  'assets/iamges/removebckclr.png',
                  fit: BoxFit.fill,
                  height: 160,
                  width: 190,
                ), // Adjusted size
                vSize(15),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                vSize(10),
                Text(
                  'Please Choose a role to sign up as',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    // fontFamily: "Sen",
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.35, // Adjust this value to position the white container
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              // child: ListView(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSize(10),
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
                    vSize(20),
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
                          fontSize: 16,
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDFDFD),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Color(0xFFF4D35E),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 40),
//             child: Column(
//               children: [
//                 Image.asset('assets/iamges/removebckclr.png', height: 170),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Log In',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Please sign in to your existing account',
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFDFDFD),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RadioListTile<String>(
//                     value: 'Customer',
//                     groupValue: userType,
//                     onChanged: (value) {
//                       setState(() {
//                         userType = value!;
//                       });
//                     },
//                     title: const Text('Customer'),
//                   ),
//                   RadioListTile<String>(
//                     value: 'Delivery boy',
//                     groupValue: userType,
//                     onChanged: (value) {
//                       setState(() {
//                         userType = value!;
//                       });
//                     },
//                     title: const Text('Delivery boy'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
