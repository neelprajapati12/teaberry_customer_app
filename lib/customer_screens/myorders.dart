import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show get;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/customer_screens/myorders_detailscreen.dart';
import 'package:teaberryapp_project/models/myorders_model.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class MyordersPage extends StatefulWidget {
  const MyordersPage({super.key});

  @override
  State<MyordersPage> createState() => _MyordersPageState();
}

class _MyordersPageState extends State<MyordersPage> {
  bool isLoading = true;
  List<MyOrdersModel> myOrders = [];

  @override
  void initState() {
    super.initState();
    getMyOrders();
  }

  getMyOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/orders/my-orders');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        setState(() {
          myOrders =
              decoded.map((order) => MyOrdersModel.fromJson(order)).toList();
          print(myOrders);
          // Sort orders by creation date (newest first)
          myOrders.sort(
            (a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorToast('Error loading orders: $e');
      print('Error loading orders: $e');
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('Error loading orders: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "MY ORDERS",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : myOrders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: myOrders.length,
                itemBuilder: (context, index) {
                  final order = myOrders[index];
                  return OrderCard(
                    orderNumber: 'ORDER NO ${order.id}',
                    status: order.status ?? 'Processing',
                    price: (order.totalPrice ?? 0.0).toDouble(),
                    imageUrl:
                        order.store?.photoUrl ??
                        'https://picsum.photos/200?random=$index',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OrderDetailsScreen(myorders: order),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String status;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color:
                            status == 'DELIVERED'
                                ? Colors.green
                                : status == 'PENDING'
                                ? Colors.orange
                                : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
