import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/deliveryboy_screens/myprofile_screen_deliveryboy.dart';
import 'package:teaberryapp_project/deliveryboy_screens/order_screen.dart';
import 'package:teaberryapp_project/models/deliveryordermodel.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class HomepageDeliveryboy extends StatefulWidget {
  @override
  State<HomepageDeliveryboy> createState() => _HomepageDeliveryboyState();
}

class _HomepageDeliveryboyState extends State<HomepageDeliveryboy> {
  List<DeliveryOrderModel> orders = [];
  bool isLoading = true;

  Future<void> fetchAllDeliveries() async {
    final url = Uri.parse(
      '${ApiConstant.baseUrl}/deliveries/boy/${SharedPreferencesHelper.getIDdeliveryboy()}',
    );
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      print("Deliveries fetched successfully");
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        orders =
            data
                .map(
                  (json) =>
                      DeliveryOrderModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load deliveries');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllDeliveries();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Initial
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreenDeliveryboy(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Logo
                  Column(
                    children: [
                      Image.asset(
                        'assets/iamges/removebckclr.png',
                        // width: w * 0.3,
                        height: h * 0.2,
                      ),
                      // Text(
                      //   'Tea berry',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // Text(
                      //   'Feel fresh',
                      //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      // ),
                    ],
                  ),
                  // Notification Icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersScreen(orders: orders),
                        ),
                      ).then((_) {
                        // Called when coming back from the product details page
                        setState(() {});
                      });
                    },
                    child: Stack(
                      children: [
                        Icon(Icons.notifications_outlined, size: 28),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFF76A04D),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${orders.length}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 5),

              // Welcome Text
              Text(
                'Hey Sagar, Good Afternoon!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 24),

              // Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.amber[300],
                    backgroundImage: AssetImage('assets/iamges/profile.jpg'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sagar Gaidhane',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'sagar.gai@gmail.com',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '+91 9xxxx xxxx2',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Stats Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF76A04D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You\'ve completed 7 deliveries\nyesterday!\nKeep it up!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Today\'s Orders: 5',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Yesterday\'s Orders: 7',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total Bonus This Month: RS. 634/-',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
