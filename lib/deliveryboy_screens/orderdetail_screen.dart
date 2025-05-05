import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text('S', style: TextStyle(color: Colors.black)),
                  ),
                  Stack(
                    children: [
                      Icon(Icons.notifications_none, size: 30),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '5',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Logo and tagline
            Column(
              children: [
                Image.asset(
                  'assets/final_logo.jpg',
                  height: 100,
                ), // Add your logo
                Text(
                  'Tea berry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  'Feel fresh',
                  style: TextStyle(fontSize: 16, color: Colors.green[600]),
                ),
                Text(
                  'Freshness is our priority',
                  style: TextStyle(fontSize: 12, color: Colors.green[600]),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Order Details Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Order Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CustomField(label: 'ORDER NUMBER', value: '231-4521'),
                      CustomField(label: 'CLIENT NAME', value: 'Vishal Sen'),
                      CustomField(
                        label: 'CLIENT REGISTRATION NO.',
                        value: '7654321',
                      ),
                      CustomField(
                        label: 'ORDER DETAILS',
                        value:
                            '1 Mac-n-cheese burger, 2 diet cokes, 1 small choco-lava cake',
                      ),
                      CustomField(label: 'PAYMENT DONE?', value: 'NO'),
                      CustomField(label: 'MODE OF PAYMENT', value: 'COD'),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'ACCEPT ORDER',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final String label;
  final String value;

  const CustomField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: TextStyle(color: Colors.grey[700])),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
