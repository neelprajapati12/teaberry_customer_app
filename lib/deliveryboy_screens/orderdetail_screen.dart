import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/deliveryboy_screens/deliverydetail_screen.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int length;
  final dynamic orderdetails;
  const OrderDetailsScreen({
    Key? key,
    required this.orderdetails,
    required this.length,
  }) : super(key: key);
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Map<int, String> subProductNames = {};
  dynamic data;
  fetchproducts() async {
    // if (subProductNames.containsKey(subProductId)) {
    //   return subProductNames[subProductId]!;
    // }
    final url = Uri.parse('${ApiConstant.baseUrl}/inventory/store/1');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
      },
    );
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      print(data);
      // final name = data['name'] ?? 'Unknown';
      // subProductNames[subProductId] = name;
      // return name;
    }
    return 'Unknown';
  }

  @override
  void initState() {
    super.initState();
    fetchproducts();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.green,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart_outlined),
      //       label: 'Orders',
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      'S',
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
                            widget.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Image.asset('assets/iamges/removebckclr.png', height: 170),

              const SizedBox(height: 16),

              const Text(
                "Order Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              buildLabel("ORDER NUMBER"),
              buildDisabledField("${widget.orderdetails.id}"),
              buildLabel("CLIENT NAME"),
              buildDisabledField("${widget.orderdetails.customer.name}"),
              buildLabel("CLIENT REGISTRATION NO."),
              buildDisabledField("${widget.orderdetails.customer.id}"),
              buildLabel("ORDER DETAILS"),
              buildLabel("ORDER DETAILS"),
              // buildOrderItems(widget.orderdetails.items),
              buildLabel("PAYMENT DONE?"),
              buildDisabledField("NO"),
              buildLabel("MODE OF PAYMENT"),
              buildDisabledField("${widget.orderdetails.paymentMethod}"),

              const SizedBox(height: 24),

              // Accept Button
              ElevatedButton(
                onPressed: () {
                  showAppToast("Order Accepted");
                  // showAppToast(msg: "Order Accepted");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DeliveryDetailsScreen(
                            orderdetails: widget.orderdetails,
                            length: widget.length,
                          ),
                    ),
                  ).then((_) {
                    // Called when coming back from the product details page
                    setState(() {});
                  });

                  // ScaffoldMessenger.of(
                  //   context,
                  // ).showSnackBar(SnackBar(content: Text("Order Accepted")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "ACCEPT ORDER",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildOrderItems(List items) {
  //   return Column(
  //     children:
  //         items.map<Widget>((item) {
  //           return FutureBuilder<String>(
  //             future: fetchSubProductName(item.subProductId),
  //             builder: (context, snapshot) {
  //               final subProductName = snapshot.data ?? 'Loading...';
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                 child: buildDisabledField(
  //                   "Qty: ${item.quantity}  |  Name: $subProductName",
  //                 ),
  //               );
  //             },
  //           );
  //         }).toList(),
  //   );
  // }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget buildDisabledField(String text) {
    return TextFormField(
      initialValue: text,
      readOnly: true,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
  }
}
