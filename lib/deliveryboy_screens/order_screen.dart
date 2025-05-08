import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  final List<Map<String, String>> orders = [
    {"name": "Anuradha Joshi", "phone": "+91 88657 84320"},
    {"name": "Shraddha P.", "phone": "+91 96642 56729"},
    {"name": "Robert Vadra", "phone": "+91 88657 99342"},
    {"name": "Vishal Sen", "phone": "+91 76532 98735"},
    {"name": "Vidya Sinha", "phone": "+91 88653 33240"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Orders',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(Icons.notifications_none, color: Colors.black),
                      ),
                      Positioned(
                        right: 6,
                        top: 4,
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
                      )
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Only Logo (Text removed)
              Image.asset(
                'assets/iamges/teaberry_logo.jpg', // Use your actual logo asset path
                height: 180,
              ),

              const SizedBox(height: 16),

              // Orders section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Orders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Orders list
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text(order["name"]!),
                      subtitle: Text(order["phone"]!),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Add navigation here if needed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text("DETAILS"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}