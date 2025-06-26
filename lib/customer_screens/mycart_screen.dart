import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/conformationscreen.dart';
import 'package:teaberryapp_project/customer_screens/payment_screen.dart';
import 'package:teaberryapp_project/models/cartservice.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String address = "27-A, Aparna apartments, Gurudev Nanak Road , Delhi ";
  bool isLoading = true;
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

  Future<void> placeorder() async {
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
          print("Parsed JSON response: $data");
        } else {
          print("Plain response: ${response.body}");
        }
        print("Order placed successfully");
        // showAppToast("Order Placed successfully");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmationScreen()),
        );
      } else {
        print("Place order failed: ${response.statusCode}");
        print("Response body: ${response.body}");
        showErrorToast(" Please try again.");
      }
    } catch (e) {
      // Navigator.of(context).pop(); // Ensure dialog is dismissed on error
      print("Signup exception: $e");
      showErrorToast("Something went wrong. Please try again.");
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
            // fontSize: 16,
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
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: fetchedCartData.length,
                        separatorBuilder:
                            (context, index) => SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          final item = fetchedCartData[index];
                          return Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      item['photoUrl'] != null
                                          ? Image.network(
                                            item['photoUrl'],
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                          : Image.asset(
                                            'assets/iamges/coffee.jpg', // also fix typo in 'images'
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                                SizedBox(width: 12),

                                // Product Details
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First Row: Title and Remove Button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: w * 0.3,
                                          child: Text(
                                            item['subProductName'] ?? '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        hSize(w * 0.1),
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                fetchedCartData.removeAt(index);
                                                CartService.removeItem(
                                                  item['productId'],
                                                  item['subProductId'],
                                                );
                                                print(
                                                  "Item removed is " +
                                                      item['subProductName'],
                                                );
                                                print(
                                                  "Cart items after removing is " +
                                                      jsonEncode(
                                                        CartService.items,
                                                      ),
                                                );
                                                print(
                                                  "Cart items after removing is " +
                                                      jsonEncode(
                                                        fetchedCartData,
                                                      ),
                                                );
                                              });
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),

                                    // Second Row: Price
                                    Text(
                                      "₹${item['price'] ?? ''}",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    // Third Row: Size and Quantity Controls
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(
                                        //   width: w * 0.15,
                                        //   child: Text(
                                        //     item.size,
                                        //     style: TextStyle(
                                        //       fontSize: 18,
                                        //       color: Colors.grey,
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          width: w * 0.15,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF8F9FB),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        hSize(w * 0.1),
                                        Container(
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (item['quantity'] > 1) {
                                                    setState(() {
                                                      item['quantity']--;
                                                      CartService.updateQuantity(
                                                        item['productId'],
                                                        item['subProductId'],
                                                        item['quantity'],
                                                      );
                                                      print(
                                                        "Item subproduct name ${item['subProductName']}quantity decreased to " +
                                                            item['quantity']
                                                                .toString(),
                                                      );
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 18,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: Text(
                                                  item['quantity'].toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                                    print(
                                                      "Item subproduct name ${item['subProductName']} quantity increased to " +
                                                          item['quantity']
                                                              .toString(),
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 18,
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
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    // Delivery Address
                    Text(
                      "DELIVERY ADDRESS",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: h * 0.06,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOTAL:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₹${CartService.totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Place Order Button
                    ElevatedButton(
                      onPressed: () {
                        // => _showOfferDialog(context)
                        placeorder();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF76A04D),
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "PLACE ORDER",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // stops: ,
                        // transform: ,
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
                        // Content
                        Stack(
                          children: [
                            // Decorative Triangles
                            ...List.generate(6, (index) {
                              return Positioned(
                                left: (index * 40.0) % 300,
                                top: (index * 25.0) % 150,
                                child: Transform.rotate(
                                  angle: index * 0.7,
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white.withOpacity(0.2),
                                    size: 14,
                                  ),
                                ),
                              );
                            }),
                            Column(
                              children: [
                                Text(
                                  'Offers!',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Congrats!',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Your first order is free!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Bonus section
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '#Referral bonus: Rs. 200',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '#Loyalty bonus: Rs. 180',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
                        Text(
                          'Use these offers for discounts!',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  Positioned(
                    top: -15,
                    right: 25,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(),
                          ),
                        );
                      },
                      child: Container(
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
                          size: 18,
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

// class CartItem {
//   String name;
//   int price;
//   int quantity;
//   String image;
//   String size;

//   CartItem({
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required this.image,
//     required this.size,
//   });
// }

// List<CartItem> cartItems = [
//     CartItem(
//       name: "Desi Filter Coffee",
//       price: 40,
//       quantity: 2,
//       image: "assets/iamges/coffee.jpg",
//       size: "400ml",
//     ),
//     CartItem(
//       name: "Pizza Calzone European",
//       price: 230,
//       quantity: 1,
//       image: "assets/iamges/pizza.jpg",
//       size: '14"',
//     ),
//   ];

  // int get totalAmount =>
  //     cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);