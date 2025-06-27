import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/deliveryboy_screens/homepage_deliveryboy.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final dynamic orderdetails;
  final int length;
  final String firstchar;

  const DeliveryDetailsScreen({
    super.key,
    this.orderdetails,
    required this.length,
    required this.firstchar,
  });
  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  int _currentIndex = 0;

  updatedeliverystatus() async {
    try {
      final url = Uri.parse(
        '${ApiConstant.baseUrl}/deliveries/${widget.orderdetails.id}/status',
      );
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
      };
      final body = jsonEncode({"status": "DELIVERED"});
      print("Body" + body);

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Delivery Successfully");
        final data = jsonDecode(response.body);
        print("Response Data: $data");
        _showOfferDialog(context);
      } else {
        print("Delivery failed: ${response.body}");
      }
    } catch (e) {
      print("Error exception: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    print("ORDER ID - ${widget.orderdetails.id}");
    // fetchproducts();
  }

  Widget build(BuildContext context) {
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
                    child: Text(
                      widget.firstchar,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Appcolors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${widget.length}",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Logo Only (Text removed)
            Column(
              children: [
                Image.asset('assets/iamges/removebckclr.png', height: 120),
              ],
            ),

            const SizedBox(height: 20),

            // Delivery Details Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delivery Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Delivery Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomField(
                      label: 'DELIVERY STATUS',
                      value: '${widget.orderdetails.status}',
                    ),
                    CustomField(
                      label: 'PAYMENT',
                      value: '${widget.orderdetails.paymentMethod}',
                    ),
                    CustomField(
                      label: 'AMOUNT TO BE COLLECTED',
                      value:
                          'Rs.${widget.orderdetails.totalPrice}/-\nAPPLICABLE TAX:  Rs.${widget.orderdetails.totalTax}/-\nTOTAL PAYABLE:  Rs.${widget.orderdetails.priceAfterTax}/-',
                    ),

                    // CustomField(
                    //   label: 'COLLECTED AMOUNT',
                    //   value: '${widget.orderdetails.priceAfterTax}',
                    // ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        // _showOfferDialog(context);
                        updatedeliverystatus();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text("Details Submitted")),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Appcolors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder:
          (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Main Container
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFCEC15C).withOpacity(0.8),
                          Color(0xFF67903D).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'The order has been delivered!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  Positioned(
                    top: -15,
                    right: 10,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop(); // close dialog

                        // Delay to ensure pop completes before navigating
                        Future.delayed(Duration(milliseconds: 100), () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/homedeliveryboy',
                            (Route<dynamic> route) => false,
                          );
                        });
                      },

                      child: Container(
                        width: 40, // make the hit area wider
                        height: 40,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 22,
                        ),
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

class CustomField extends StatelessWidget {
  final String label;
  final String value;

  const CustomField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }
}
