import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
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
        showAppToast("Failed to update delivery status");
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
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 5),
                vertical: ResponsiveSize.height(context, 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.grey.shade200,
                  //     child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  //   ),
                  // ),
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
                          padding: EdgeInsets.all(
                            ResponsiveSize.width(context, 1),
                          ),
                          decoration: BoxDecoration(
                            color: Appcolors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${widget.length}",
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
            ),

            // Logo Only (Text removed)
            Column(
              children: [
                Image.asset(
                  'assets/iamges/logo.png',
                  height: ResponsiveSize.height(context, 18),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Delivery Details Heading
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 5),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delivery Details',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Delivery Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 5),
                ),
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
                        minimumSize: Size(
                          double.infinity,
                          ResponsiveSize.height(context, 6),
                        ),
                        backgroundColor: Appcolors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.width(context, 3),
                          ),
                        ),
                      ),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: ResponsiveSize.font(context, 4),
                          color: Colors.white,
                        ),
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
                    margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 5),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveSize.height(context, 2.5),
                      horizontal: ResponsiveSize.width(context, 6),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFCEC15C).withOpacity(0.8),
                          Color(0xFF67903D).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveSize.width(context, 5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: ResponsiveSize.width(context, 3.75),
                          spreadRadius: ResponsiveSize.width(context, 0.5),
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
                            fontSize: ResponsiveSize.font(context, 6),
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
                        width: ResponsiveSize.width(context, 10),
                        height: ResponsiveSize.width(context, 10),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(
                          ResponsiveSize.width(context, 1),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: ResponsiveSize.width(context, 1.25),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: ResponsiveSize.width(context, 5.5),
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
      padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveSize.font(context, 3.2),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 0.8)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(
                ResponsiveSize.width(context, 2.5),
              ),
            ),
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }
}
