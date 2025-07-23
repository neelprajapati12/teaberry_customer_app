import 'package:flutter/material.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
import 'package:teaberryapp_project/customer_screens/conformationscreen.dart';
import 'package:teaberryapp_project/customer_screens/mycart_screen.dart';
import 'package:teaberryapp_project/customer_screens/myorders.dart';
import 'package:teaberryapp_project/customer_screens/product_detailspage.dart';
import 'package:teaberryapp_project/customer_screens/selectionscreen.dart';
import 'package:teaberryapp_project/customer_screens/wallet_screen.dart';
import 'package:teaberryapp_project/deliveryboy_screens/deliverydetail_screen.dart';
import 'package:teaberryapp_project/deliveryboy_screens/homepage_deliveryboy.dart';
import 'package:teaberryapp_project/deliveryboy_screens/myprofile_screen_deliveryboy.dart';
import 'package:teaberryapp_project/deliveryboy_screens/order_screen.dart';
import 'package:teaberryapp_project/deliveryboy_screens/orderdetail_screen.dart';
import 'package:teaberryapp_project/deliveryboy_screens/signup_delivery_boy.dart';
import 'package:teaberryapp_project/getinitialpage.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import 'package:teaberryapp_project/shared_pref.dart';
// import 'package:teaberryapp_project/mycart_screen.dart';
// import 'package:teaberryapp_project/resturantview_screen.dart';
import 'package:teaberryapp_project/signup_screen.dart';
import 'package:teaberryapp_project/verification_screen.dart';

import 'customer_screens/signup_otp_verification.dart';
// import 'package:teaberryapp_project/verification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferencesHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tea Berry',
      debugShowCheckedModeBanner: false,
      routes: {
        '/homedeliveryboy':
            (context) => HomepageDeliveryboy(), // Add your home screen route
      },
      home:
          // WalletScreen(),
          getInitialPage(),
      // ConfirmationScreen(),
      // LoginPage(),
      // BottomNavbarCustomer(),
      // SharedPreferencesHelper.getIsLoggedIn() == true
      //     ? BottomNavbarCustomer()
      //     : LoginPage(),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(home: SignUpScreen()));
// }
//
// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   bool _hidePassword = true;
//   bool _hideConfirmPassword = true;
//
//   String? selectedRole;
//   String? selectedStore;
//
//   final roles = ['Customer', 'Seller'];
//   final stores = ['Store 1', 'Store 2'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Yellow Header with Logo and Text
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xFFFFD966), // Light Yellow
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.arrow_back_ios, color: Colors.black),
//                       ),
//                       Spacer(),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Image.asset(
//                     'assets/iamges/teaberry_logo.jpg',
//                     height: 60,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Sign Up",
//                     style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                   ),
//                   Text(
//                     "Please sign up to get started",
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Form Body
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(labelText: "Sign up as"),
//                       items: roles
//                           .map((role) => DropdownMenuItem(
//                           value: role, child: Text(role)))
//                           .toList(),
//                       onChanged: (val) => setState(() => selectedRole = val),
//                     ),
//                     TextField(
//                         decoration: InputDecoration(
//                             labelText: "Name",
//                             hintText: "Adam Doe",
//                             filled: true,
//                             fillColor: Colors.grey.shade100)),
//                     TextField(
//                         decoration: InputDecoration(
//                             labelText: "Mobile No",
//                             filled: true,
//                             fillColor: Colors.grey.shade100)),
//                     TextField(
//                         decoration: InputDecoration(
//                             labelText: "Email",
//                             filled: true,
//                             fillColor: Colors.grey.shade100)),
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(labelText: "Nearest Store"),
//                       items: stores
//                           .map((store) => DropdownMenuItem(
//                           value: store, child: Text(store)))
//                           .toList(),
//                       onChanged: (val) => setState(() => selectedStore = val),
//                     ),
//                     TextField(
//                         decoration: InputDecoration(
//                             labelText: "Address",
//                             filled: true,
//                             fillColor: Colors.grey.shade100)),
//                     TextField(
//                       obscureText: _hidePassword,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         suffixIcon: IconButton(
//                           icon: Icon(_hidePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility),
//                           onPressed: () =>
//                               setState(() => _hidePassword = !_hidePassword),
//                         ),
//                       ),
//                     ),
//                     TextField(
//                       obscureText: _hideConfirmPassword,
//                       decoration: InputDecoration(
//                         labelText: "Re-type Password",
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         suffixIcon: IconButton(
//                           icon: Icon(_hideConfirmPassword
//                               ? Icons.visibility_off
//                               : Icons.visibility),
//                           onPressed: () => setState(() =>
//                           _hideConfirmPassword = !_hideConfirmPassword),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green[700],
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         minimumSize: Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                       ),
//                       child:
//                       Text("SIGN UP", style: TextStyle(fontSize: 16)),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
