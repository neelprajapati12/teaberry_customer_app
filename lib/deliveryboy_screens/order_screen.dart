import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/deliveryboy_screens/orderdetail_screen.dart';
import 'package:teaberryapp_project/models/deliveryordermodel.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class OrdersScreen extends StatefulWidget {
  final List<DeliveryOrderModel> orders;
  final String firstchar;

  const OrdersScreen({
    super.key,
    required this.orders,
    required this.firstchar,
  });
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // fetchAllDeliveries();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
                    child: Text(
                      widget.firstchar,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        right: 6,
                        top: 4,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Appcolors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${widget.orders.length}",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Only Logo (Text removed)
              Image.asset(
                'assets/iamges/removebckclr.png', // Use your actual logo asset path
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
                  itemCount: widget.orders.length,
                  itemBuilder: (context, index) {
                    final order = widget.orders[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Icons.check_circle, color: Appcolors.green),
                      title: Text("${order.customer!.name}"),
                      subtitle: Text("${order.customer!.mobile}"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OrderDetailsScreen(
                                    orderdetails: order,
                                    length: widget.orders.length,
                                    firstchar: widget.firstchar,
                                    // orderid:widget.orders.id,
                                  ),
                            ),
                          ).then((_) {
                            // Called when coming back from the product details page
                            setState(() {});
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          "DETAILS",
                          style: TextStyle(color: Colors.white),
                        ),
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


// final List<Map<String, String>> orders = [
  //   {"name": "Anuradha Joshi", "phone": "+91 88657 84320"},
  //   {"name": "Shraddha P.", "phone": "+91 96642 56729"},
  //   {"name": "Robert Vadra", "phone": "+91 88657 99342"},
  //   {"name": "Vishal Sen", "phone": "+91 76532 98735"},
  //   {"name": "Vidya Sinha", "phone": "+91 88653 33240"},
  // ];

  // List<DeliveryOrderModel> orders = [];
  // bool isLoading = true;

  // Future<void> fetchAllDeliveries() async {
  //   final url = Uri.parse(
  //     '${ApiConstant.baseUrl}/deliveries/boy/${SharedPreferencesHelper.getIDdeliveryboy()}',
  //   );
  //   print(url);

  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization':
  //           'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     print("Deliveries fetched successfully");
  //     final List<dynamic> data = json.decode(response.body);
  //     setState(() {
  //       orders =
  //           data
  //               .map(
  //                 (json) =>
  //                     DeliveryOrderModel.fromJson(json as Map<String, dynamic>),
  //               )
  //               .toList();
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     throw Exception('Failed to load deliveries');
  //   }
  // }
