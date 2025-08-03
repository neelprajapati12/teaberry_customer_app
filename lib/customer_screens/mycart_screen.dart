import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/discount_dialog.dart';
import 'package:teaberryapp_project/constants/referral_dialog.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/customer_screens/conformationscreen.dart';
import 'package:teaberryapp_project/customer_screens/payment_screen.dart';
import 'package:teaberryapp_project/models/cartservice.dart';
import 'package:teaberryapp_project/models/myorders_model.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class CartPage extends StatefulWidget {
  final dynamic customeraddress;

  const CartPage({super.key, this.customeraddress});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String address = "27-A, Aparna apartments, Gurudev Nanak Road , Delhi ";
  bool isLoading = false;
  String error = '';

  // List<Inventories1> products = [];
  List<dynamic> fetchedCartData = [];

  Future<void> fetchCart() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });
      print("APi called");

      final token = await SharedPreferencesHelper.getTokencustomer();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/auth/profile'), // Adjust as needed
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("APi call success");
        final jsonResponse = json.decode(response.body);
        final store = jsonResponse['store'];

        if (store != null && store['inventories'] != null) {
          List<dynamic> inventories = store['inventories'];

          // 🔍 Build cart products based on CartService.items
          List<Map<String, dynamic>> matchedCartItems = [];

          for (final cartItem in CartService.items) {
            final productId = cartItem['productId'];
            final subProductId = cartItem['subProductId'];

            final matchingInventory = inventories.firstWhere(
              (inv) => inv['id'] == productId,
              orElse: () => null,
            );

            if (matchingInventory != null) {
              final matchingSubProduct =
                  (matchingInventory['subProducts'] as List).firstWhere(
                    (sub) => sub['id'] == subProductId,
                    orElse: () => null,
                  );

              if (matchingSubProduct != null) {
                matchedCartItems.add({
                  'product': matchingInventory['name'],
                  'productId': productId,
                  'subProductId': subProductId,
                  'subProductName': matchingSubProduct['name'],
                  'price': matchingSubProduct['price'],
                  'quantity': cartItem['quantity'],
                  'photoUrl': matchingSubProduct['photoUrl'],
                });
              }
            }
          }

          // ✅ Save this to your state
          setState(() {
            fetchedCartData = matchedCartItems;
            print('✅ Fetched Cart Data: $fetchedCartData');
            isLoading = false;
          });
        } else {
          setState(() {
            error = 'No inventories found.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to fetch cart data.';
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> payloadItems =
      CartService.items.map((item) {
        return {
          'productId': item['productId'],
          'subProductId': item['subProductId'],
          'quantity': item['quantity'],
        };
      }).toList();

  var orderid;

  Future<void> placeorder() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/orders');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwicm9sZXMiOlsiUk9MRV9DVVNUT01FUiJdLCJpYXQiOjE3NTAwODI4NjUsImV4cCI6MTc1MDE2OTI2NX0.GucN0gkM6vMKJjswN4LW9rXC4kUIfxjxTSo_Gxc0UAebLud-0fvZjMTZmlVNDq0l12nF_KHye5boqNIADcnwyA',
            'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
      };
      final body = jsonEncode({
        //   "customerId": 3,
        //   "storeId": 1,
        "items": payloadItems,
        "paymentMethod": "ONLINE",
      });
      print(body);
      final response = await http.post(url, headers: headers, body: body);

      // Navigator.of(context).pop(); // Hide loading dialog

      if (response.statusCode == 200) {
        // Check if response is JSON or plain text
        final contentType = response.headers['content-type'] ?? '';
        if (contentType.contains('application/json')) {
          final data = jsonDecode(response.body);
          orderid = data['id'];
          print("Parsed JSON response: $data");
        } else {
          print("Plain response: ${response.body}");
        }
        print("Order placed successfully");
        print("CHECKING DISCOUNT OR REFERRAL");

        checkfordiscountORreferral(orderid);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ConfirmationScreen()),
        // );
      } else {
        print("Place order failed: ${response.statusCode}");
        print("Response body: ${response.body}");
        showErrorToast(" Please try again.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Navigator.of(context).pop(); // Ensure dialog is dismissed on error
      print("Signup exception: $e");
      showErrorToast("Something went wrong. Please try again.");
    }
  }

  List<MyOrdersModel> myOrders = [];

  Future<void> checkfordiscountORreferral(var orderid) async {
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
        print("CHECKING DISCOUNT OR REFERRAL FUNC STATUS 200");
        final List<dynamic> decoded = json.decode(response.body);
        setState(() {
          myOrders =
              decoded.map((order) => MyOrdersModel.fromJson(order)).toList();

          // Fix the return type error by providing a default MyOrdersModel
          MyOrdersModel? currentOrder = myOrders.firstWhere(
            (order) => order.id == orderid,
            orElse: () => MyOrdersModel(), // Return empty model instead of null
          );
          fetchedCartData.clear();
          CartService.items.clear();
          CartService.clearCart();
          // CartService.totalPrice = 0;

          if (currentOrder.id != null) {
            // Check if it's a valid order
            if (currentOrder.discountAmount != null &&
                currentOrder.discountAmount! > 0) {
              print("LOYALTY BONUS APPLIED");
              DiscountDialog.show(context, currentOrder);
            } else if (currentOrder.customer?.walletBalance != null &&
                currentOrder.customer!.walletBalance! > 0 &&
                CartService.totalPrice > 500 &&
                currentOrder.ordersUntilNextDiscount != 4) {
              print("REFFREAL BONUS APPLIED");
              ReferralDialog.show(context, currentOrder);
            } else {
              print("NOTHING APPLIED");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(myorders: currentOrder),
                ),
              );
            }
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(myorders: currentOrder),
              ),
            );
          }
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("Into intit");
    print("Cart items are " + jsonEncode(CartService.items));
    fetchCart();
  }

  Widget build(BuildContext context) {
    print("Cart total price is " + CartService.totalPrice.toStringAsFixed(2));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Cart",
          style: TextStyle(
            fontSize: ResponsiveSize.font(context, 4.5),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 16),
          //   child: Text(
          //     "DONE",
          //     style: TextStyle(
          //       color: Color(0xFF35C759),
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
        ],
      ),
      body:
          fetchedCartData.isEmpty
              ? Center(
                child:
                    isLoading
                        ? CircularProgressIndicator()
                        : error.isNotEmpty
                        ? Text(error)
                        : Text("Your cart is empty!"),
              )
              : SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Appcolors.green,
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: fetchedCartData.length,
                          separatorBuilder:
                              (context, index) => SizedBox(
                                height: ResponsiveSize.height(context, 1.8),
                              ),
                          itemBuilder: (context, index) {
                            final item = fetchedCartData[index];
                            return Container(
                              padding: EdgeInsets.all(
                                ResponsiveSize.width(context, 3),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8F9FB),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.width(context, 3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveSize.width(context, 2),
                                    ),
                                    child:
                                        item['photoUrl'] != null
                                            ? Image.network(
                                              item['photoUrl'],
                                              width: ResponsiveSize.width(
                                                context,
                                                30,
                                              ),
                                              height: ResponsiveSize.height(
                                                context,
                                                15,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              'assets/iamges/coffee.jpg',
                                              width: ResponsiveSize.width(
                                                context,
                                                30,
                                              ),
                                              height: ResponsiveSize.height(
                                                context,
                                                15,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                  SizedBox(
                                    width: ResponsiveSize.width(context, 3),
                                  ),

                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // First Row: Title and Remove Button
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item['subProductName'] ?? '',
                                                style: TextStyle(
                                                  fontSize: ResponsiveSize.font(
                                                    context,
                                                    4.5,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: ResponsiveSize.width(
                                                context,
                                                2,
                                              ),
                                            ),
                                            Container(
                                              width: ResponsiveSize.width(
                                                context,
                                                8,
                                              ),
                                              height: ResponsiveSize.width(
                                                context,
                                                8,
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    fetchedCartData.removeAt(
                                                      index,
                                                    );
                                                    CartService.removeItem(
                                                      item['productId'],
                                                      item['subProductId'],
                                                    );
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: ResponsiveSize.width(
                                                    context,
                                                    4.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: ResponsiveSize.height(
                                            context,
                                            1,
                                          ),
                                        ),

                                        // Second Row: Price
                                        Text(
                                          "₹${item['price'] ?? ''}",
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.font(
                                              context,
                                              6,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: ResponsiveSize.height(
                                            context,
                                            1,
                                          ),
                                        ),

                                        // Third Row: Quantity Controls
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: ResponsiveSize.width(
                                                context,
                                                8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      ResponsiveSize.width(
                                                        context,
                                                        4,
                                                      ),
                                                    ),
                                              ),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (item['quantity'] >
                                                          1) {
                                                        setState(() {
                                                          item['quantity']--;
                                                          CartService.updateQuantity(
                                                            item['productId'],
                                                            item['subProductId'],
                                                            item['quantity'],
                                                          );
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      width:
                                                          ResponsiveSize.width(
                                                            context,
                                                            8,
                                                          ),
                                                      height:
                                                          ResponsiveSize.width(
                                                            context,
                                                            8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size:
                                                            ResponsiveSize.width(
                                                              context,
                                                              4.5,
                                                            ),
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          ResponsiveSize.width(
                                                            context,
                                                            3,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      item['quantity']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            ResponsiveSize.font(
                                                              context,
                                                              3.5,
                                                            ),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        item['quantity']++;
                                                        CartService.updateQuantity(
                                                          item['productId'],
                                                          item['subProductId'],
                                                          item['quantity'],
                                                        );
                                                      });
                                                    },
                                                    child: Container(
                                                      width:
                                                          ResponsiveSize.width(
                                                            context,
                                                            8,
                                                          ),
                                                      height:
                                                          ResponsiveSize.width(
                                                            context,
                                                            8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        size:
                                                            ResponsiveSize.width(
                                                              context,
                                                              4.5,
                                                            ),
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.2)),
                      // Delivery Address
                      Text(
                        "DELIVERY ADDRESS",
                        style: TextStyle(
                          fontSize: ResponsiveSize.font(context, 3),
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                      Container(
                        height: ResponsiveSize.height(context, 6),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.width(context, 4),
                          vertical: ResponsiveSize.height(context, 1.5),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.width(context, 3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.customeraddress,
                            style: TextStyle(
                              fontSize: ResponsiveSize.font(context, 3.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.2)),

                      // Total Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TOTAL:",
                            style: TextStyle(
                              fontSize: ResponsiveSize.font(context, 3.5),
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "₹${CartService.totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: ResponsiveSize.font(context, 4.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.2)),

                      // Place Order Button
                      ElevatedButton(
                        onPressed: () {
                          placeorder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF76A04D),
                          minimumSize: Size(
                            double.infinity,
                            ResponsiveSize.height(context, 7),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.width(context, 3),
                            ),
                          ),
                        ),
                        child: Text(
                          "PLACE ORDER",
                          style: TextStyle(
                            fontSize: ResponsiveSize.font(context, 4),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.2)),
                    ],
                  ),
                ),
              ),
    );
  }
}
