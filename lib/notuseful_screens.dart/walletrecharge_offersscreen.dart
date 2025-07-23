// import 'package:flutter/material.dart';
// import 'package:teaberryapp_project/notuseful_screens.dart/walletrecharge_lastscreen.dart';
// // import 'package:teaberryapp_project/walletrecharge_lastscreen.dart';

// class WalletRechargeOfferScreen extends StatefulWidget {
//   @override
//   State<WalletRechargeOfferScreen> createState() =>
//       _WalletRechargeOfferScreenState();
// }

// class _WalletRechargeOfferScreenState extends State<WalletRechargeOfferScreen> {
//   final TextEditingController userIdController = TextEditingController(
//     text: "+91 88888 34213",
//   );
//   final TextEditingController amountController = TextEditingController(
//     text: "2000",
//   );

//   bool showOffersPopup = true;

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Main content
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 40),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF4CE5E),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'assets/iamges/teaberry_logo.jpg', // Update with your asset path
//                       height: 80,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "Tea berry",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green[800],
//                       ),
//                     ),
//                     Text(
//                       "Feel fresh\nFreshness is our priority",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 13, color: Colors.green[900]),
//                     ),
//                   ],
//                 ),
//               ),

//               // Wallet recharge content
//               SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Wallet Recharge",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       "Please enter the amount to recharge.",
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                     SizedBox(height: 30),
//                     Text("USER ID", style: TextStyle(color: Colors.grey[700])),
//                     SizedBox(height: 6),
//                     TextField(
//                       controller: userIdController,
//                       readOnly: true,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 14,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       "ENTER AMOUNT",
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 6),
//                     TextField(
//                       controller: amountController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 14,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RechargeSuccessScreen(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "RECHARGE",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // Offers Popup Modal
//           if (showOffersPopup)
//             Center(
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 25),
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.green.withOpacity(0.95),
//                       Colors.lightGreen.withOpacity(0.95),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Offers!",
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         Text(
//                           "You are eligible for these offers!\n\nRecharge with these offers for additional",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 14, color: Colors.white),
//                         ),
//                         SizedBox(height: 12),
//                         Text(
//                           "10% on Rs. 500\n15% on Rs. 1000\n20% on Rs. 2000!",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),

//                     // Close Button
//                     Positioned(
//                       top: -20,
//                       right: -20,
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             showOffersPopup = false;
//                           });
//                         },
//                         child: CircleAvatar(
//                           backgroundColor: Color(0xFFFAD883),
//                           child: Icon(Icons.close, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
