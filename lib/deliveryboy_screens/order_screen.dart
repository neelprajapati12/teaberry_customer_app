import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/deliveryboy_screens/delivered_order_detailspage.dart';
import 'package:teaberryapp_project/deliveryboy_screens/orderdetail_screen.dart';
import 'package:teaberryapp_project/deliveryboy_screens/orderdetail_screen_new.dart'
    show OrderDetailsScreen;
import 'package:teaberryapp_project/models/deliveryordermodel.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class OrdersScreen extends StatefulWidget {
  final List<DeliveryOrderModel> orders;
  final List<DeliveryOrderModel> deliveredorders;
  final String firstchar;

  const OrdersScreen({
    super.key,
    required this.orders,
    required this.firstchar,
    required this.deliveredorders,
  });
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

enum OrderFilter { latest, delivered }

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.orders);
    // fetchAllDeliveries();
  }

  OrderFilter selectedFilter = OrderFilter.latest;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 4),
            vertical: ResponsiveSize.height(context, 1.5),
          ),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
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
                          padding: EdgeInsets.all(
                            ResponsiveSize.width(context, 1),
                          ),
                          decoration: BoxDecoration(
                            color: Appcolors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${widget.orders.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveSize.font(context, 2.5),
                            ),
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
                'assets/iamges/logo.png',
                height: ResponsiveSize.height(context, 20),
              ),

              SizedBox(height: ResponsiveSize.height(context, 2)),
              // Orders section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 3),
                  vertical: ResponsiveSize.height(context, 1),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.width(context, 3),
                  ),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OrderFilter>(
                    value: selectedFilter,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 2,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: ResponsiveSize.font(context, 4),
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (OrderFilter? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedFilter = newValue;
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: OrderFilter.latest,
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_shipping,
                              color: Appcolors.green,
                              size: ResponsiveSize.width(context, 5),
                            ),
                            const SizedBox(width: 8),
                            const Text('Latest Orders'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: OrderFilter.delivered,
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Appcolors.green,
                              size: ResponsiveSize.width(context, 5),
                            ),
                            const SizedBox(width: 8),
                            const Text('Delivered Orders'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Orders section title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedFilter == OrderFilter.latest
                      ? "Latest Orders (${widget.orders.length})"
                      : "Delivered Orders (${widget.deliveredorders.length})",
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 4.5),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Orders list
              Expanded(
                child:
                    selectedFilter == OrderFilter.latest
                        ? _buildOrdersList(widget.orders)
                        : _buildOrdersList(widget.deliveredorders),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<DeliveryOrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          "No orders available",
          style: TextStyle(
            fontSize: ResponsiveSize.font(context, 4.5),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.height(context, 1),
            horizontal: ResponsiveSize.width(context, 2),
          ),
          leading: Icon(
            selectedFilter == OrderFilter.latest
                ? Icons.local_shipping
                : Icons.check_circle,
            color: Appcolors.green,
            size: ResponsiveSize.width(context, 6),
          ),
          title: Text(
            order.customer?.name ?? 'Unknown',
            style: TextStyle(
              fontSize: ResponsiveSize.font(context, 4),
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            order.customer?.mobile ?? 'No contact',
            style: TextStyle(
              fontSize: ResponsiveSize.font(context, 3.5),
              color: Colors.grey[600],
            ),
          ),
          trailing: ElevatedButton(
            onPressed: () {
              if (selectedFilter == OrderFilter.latest) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => OrderDetailsScreen(
                          orderdetails: order,
                          length: orders.length,
                          firstchar: widget.firstchar,
                        ),
                  ),
                ).then((_) => setState(() {}));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DeliveredOrderDetailspage(
                          orderdetails: order,
                          length: orders.length,
                          firstchar: widget.firstchar,
                        ),
                  ),
                ).then((_) => setState(() {}));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveSize.width(context, 3),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 4),
                vertical: ResponsiveSize.height(context, 1),
              ),
            ),
            child: Text(
              selectedFilter == OrderFilter.latest ? "DETAILS" : "VIEW",
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveSize.font(context, 3.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
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
