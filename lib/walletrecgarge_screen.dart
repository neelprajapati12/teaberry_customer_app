import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/walletrecharge_offersscreen.dart';

class WalletRechargeScreen extends StatelessWidget {
  final TextEditingController userIdController = TextEditingController(
    // text: "+91 88888 34213",
  );
  final TextEditingController amountController = TextEditingController(
    // text: "2000",
  );

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Yellow top section with logo and title
          Container(
            color: Appcolors.yellow,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                vSize(10),
                Image.asset(
                  'assets/iamges/teaberry_logo.jpg',
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 15),
                Text(
                  'Wallet Recharge',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please enter the amount to recharge.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),

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
                    vSize(10),
                    Text(
                      "USER ID",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomTextFormField(
                      controller: userIdController,
                      hintText: "+91 88888 34213",
                      // readOnly: true,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "ENTER AMOUNT",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomTextFormField(
                      controller: amountController,
                      hintText: "2000",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => RechargeSuccessScreen(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "RECHARGE",
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
