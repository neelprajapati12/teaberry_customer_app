import 'package:flutter/material.dart';

class HomepageDeliveryboy extends StatefulWidget {
  @override
  State<HomepageDeliveryboy> createState() => _HomepageDeliveryboyState();
}

class _HomepageDeliveryboyState extends State<HomepageDeliveryboy> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(child: Text('S')),
                    Column(
                      children: [
                        Image.asset(
                          'assets/iamges/final_logo.jpg', // Replace with your logo
                          height: 80,
                        ),
                        Text(
                          'Tea berry\nFeel fresh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Icon(Icons.notifications_none, size: 30),
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.green,
                            child: Text(
                              '5',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hey Sagar, Good Afternoon!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // User Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        '',
                      ), // Replace with your image
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sagar Gaidhane',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('sagar.gai@gmail.com'),
                        Text('+91 9xxxx xxxx2'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Green Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'You’ve completed 7 deliveries\nyesterday!\nKeep it up!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Today\'s Orders: 5'),
                            Text('Yesterday\'s Orders: 7'),
                            Text('Total Bonus This Month: RS. 634/-'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
