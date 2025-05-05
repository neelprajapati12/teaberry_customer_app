import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Map<String, String>> orders = [
    {'name': 'Anuradha Joshi', 'phone': '+91 88657 84320'},
    {'name': 'Shraddha P.', 'phone': '+91 96642 56729'},
    {'name': 'Robert Vadra', 'phone': '+91 88657 99342'},
    {'name': 'Vishal Sen', 'phone': '+91 76532 98735'},
    {'name': 'Vidya Sinha', 'phone': '+91 88653 33240'},
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
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
                  'assets/tea_berry_logo.png',
                  height: 100,
                ), // Add your logo in assets folder
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
            // Orders title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Orders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Orders list
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text(orders[index]['name'] ?? ''),
                    subtitle: Text(orders[index]['phone'] ?? ''),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('DETAILS'),
                    ),
                  );
                },
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
          // You can add more items if needed
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
