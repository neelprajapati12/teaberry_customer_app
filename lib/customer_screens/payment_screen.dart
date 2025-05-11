import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/myprofile.screen_customer.dart';
// import 'package:teaberryapp_project/myprofile.screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedMethod = 2;

  final List<Map<String, dynamic>> paymentMethods = [
    {"label": "Cash", "icon": Icons.money},
    {"label": "UPI", "icon": Icons.account_balance_wallet},
    {"label": "Debit Card", "icon": Icons.credit_card},
    {"label": "PayPal", "icon": Icons.account_balance},
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Method Selection
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: paymentMethods.length,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  bool isSelected = selectedMethod == index;
                  return Container(
                    width: 100,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.white : const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          isSelected
                              ? Border.all(color: Color(0xFF35C759), width: 2)
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          paymentMethods[index]['icon'],
                          color: isSelected ? Color(0xFF35C759) : Colors.grey,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          paymentMethods[index]['label'],
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),

            // Card Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Image.asset('assets/iamges/payment_screen.png', height: 120),
                  SizedBox(height: 15),
                  Text(
                    "No master card added",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You can add a mastercard and\nsave it for later",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Add New Button
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, color: Color(0xFF35C759)),
              label: Text(
                "ADD NEW",
                style: TextStyle(
                  color: Color(0xFF35C759),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            Spacer(),

            // Total Amount
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL:",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Text(
                    "₹295",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Pay & Confirm Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreenCustomer(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF76A04D),
                minimumSize: Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "PAY & CONFIRM",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
