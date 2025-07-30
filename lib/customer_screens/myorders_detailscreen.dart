import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/models/myorders_model.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class OrderDetailsScreen extends StatefulWidget {
  final MyOrdersModel myorders;

  const OrderDetailsScreen({super.key, required this.myorders});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List<dynamic> inventoryData = [];
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  bool isLoading = true;
  String error = '';
  List<Inventories1> products = [];

  Future<void> fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      print('Fetching products from: ${ApiConstant.baseUrl}/auth/profile');
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwicm9sZXMiOlsiUk9MRV9DVVNUT01FUiJdLCJpYXQiOjE3NTAwODI4NjUsImV4cCI6MTc1MDE2OTI2NX0.GucN0gkM6vMKJjswN4LW9rXC4kUIfxjxTSo_Gxc0UAebLud-0fvZjMTZmlVNDq0l12nF_KHye5boqNIADcnwyA',
              'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final store = jsonResponse['store'];
        if (store != null) {
          final inventories = store['inventories'] as List;
          setState(() {
            products =
                inventories.map((json) => Inventories1.fromJson(json)).toList();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to load products';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  String getSubProductName(int productId, int subProductId) {
    print("Looking for productId: $productId, subProductId: $subProductId");

    try {
      // Find the inventory item
      final inventory =
          products.where((inv) => inv.id == productId).isNotEmpty
              ? products.firstWhere((inv) => inv.id == productId)
              : null;

      if (inventory != null && inventory.subProducts != null) {
        // Find the sub-product
        final subProduct =
            inventory.subProducts!
                    .where((sp) => sp.id == subProductId)
                    .isNotEmpty
                ? inventory.subProducts!.firstWhere(
                  (sp) => sp.id == subProductId,
                )
                : null;

        if (subProduct != null) {
          return subProduct.name ?? 'Unknown';
        }
      }
    } catch (e) {
      print("Error finding product name: $e");
    }
    return 'Unknown';
  }

  Widget buildOrderItems(List<Items> items) {
    return Column(
      children:
          items.map<Widget>((item) {
            final int productId = item.productId?.toInt() ?? 0;
            final int subProductId = item.subProductId?.toInt() ?? 0;

            print(
              "Searching for - Product ID: $productId, SubProduct ID: $subProductId",
            );
            final String subProductName = getSubProductName(
              productId,
              subProductId,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSize(6),
                Text(
                  subProductName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Quantity and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Qty: ${item.quantity}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "₹${item.price?.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Order Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            // fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(child: Text(error))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    widget.myorders.store?.photoUrl ??
                                        'https://picsum.photos/200?random=1',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ORDER NO ${widget.myorders.id.toString()}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.myorders.status!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              widget.myorders.status ==
                                                      'DELIVERED'
                                                  ? Colors.green
                                                  : widget.myorders.status ==
                                                      'PENDING'
                                                  ? Colors.orange
                                                  : Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${widget.myorders.totalPrice}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            const Text(
                              'Order Summary',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            buildOrderItems(widget.myorders.items!),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '${widget.myorders.originalPrice}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.myorders.discountAmount! > 0) ...{
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Discount',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '- ₹${widget.myorders.discountAmount}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'After Discount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '${widget.myorders.totalPrice}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            },
                          ],
                        ),
                      ),
                    ),
                    vSize(10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery Address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('${widget.myorders.address}'),
                            const SizedBox(height: 16),
                            const Text(
                              'Mobile Number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('${widget.myorders.customer!.mobile}'),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(height: 16),
                    // const Text(
                    //   'Delivery Address',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 18,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // Text('${widget.myorders.address}'),
                    // const SizedBox(height: 16),
                    // const Text(
                    //   'Mobile Number',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 18,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // Text('${widget.myorders.customer!.mobile}'),
                  ],
                ),
              ),
    );
  }

  Widget _buildOrderItem(String name, double price, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name x$quantity'),
          Text('\$${(price * quantity).toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
