import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/myprofile.screen.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSize(30),
            // Back button and title
            Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Color(0xFFF1F6FB),
                  child: Icon(Icons.arrow_back_ios, color: Colors.black),
                  radius: 16,
                ),
                SizedBox(width: 12),
                Text(
                  "Payment",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Payment Method Selection
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: paymentMethods.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  bool isSelected = selectedMethod == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMethod = index;
                      });
                    },
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFFE3F9EB)
                                : const Color(0xFFF1F6FB),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            isSelected
                                ? Border.all(
                                  color: const Color(0xFF4CAF50),
                                  width: 2,
                                )
                                : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            paymentMethods[index]['icon'],
                            color:
                                isSelected
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            paymentMethods[index]['label'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.black : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Card Placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.asset('assets/iamges/payment_screen.png', height: 100),
                  const SizedBox(height: 12),
                  const Text(
                    "No master card added",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "You can add a mastercard\nand save it for later",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Add New Button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Color(0xFF4CAF50)),
              label: const Text(
                "ADD NEW",
                style: TextStyle(color: Color(0xFF4CAF50)),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),

            // Total and Confirm Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "TOTAL:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "₹295",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AAC4B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "PAY & CONFIRM",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
