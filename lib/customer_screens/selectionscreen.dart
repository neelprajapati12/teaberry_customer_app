import 'package:flutter/material.dart';

class RadioSelectionScreen extends StatefulWidget {
  @override
  _RadioSelectionScreenState createState() => _RadioSelectionScreenState();
}

class _RadioSelectionScreenState extends State<RadioSelectionScreen> {
  String userType = 'Customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF4D35E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Image.asset(
                  'assets/iamges/removebckclr.png',
                  height: 170,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please sign in to your existing account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFDFDFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    value: 'Customer',
                    groupValue: userType,
                    onChanged: (value) {
                      setState(() {
                        userType = value!;
                      });
                    },
                    title: const Text('Customer'),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}