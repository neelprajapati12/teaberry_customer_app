import 'package:flutter/material.dart';
import 'package:teaberryapp_project/walletrecharge_offersscreen.dart';

// void main() => runApp(TeaBerryRechargeApp());
//
// class TeaBerryRechargeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Wallet Recharge',
//       debugShowCheckedModeBanner: false,
//       home: WalletRechargeScreen(),
//     );
//   }
// }

class WalletRechargeScreen extends StatelessWidget {
  final TextEditingController userIdController =
  TextEditingController(text: "+91 88888 34213");
  final TextEditingController amountController =
  TextEditingController(text: "2000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Yellow top section with logo and title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Color(0xFFF4CE5E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/iamges/teaberry_logo.jpg', // Add your logo image here
                  height: 80,
                ),
                SizedBox(height: 10),
                Text(
                  "Tea berry",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  "Feel fresh\nFreshness is our priority",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green[900],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Wallet Recharge",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Please enter the amount to recharge.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 30),
                Text("USER ID", style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 6),
                TextField(
                  controller: userIdController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("ENTER AMOUNT", style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 6),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WalletRechargeOfferScreen(),
                          ),
                      );
                    // Handle recharge logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text("RECHARGE", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}