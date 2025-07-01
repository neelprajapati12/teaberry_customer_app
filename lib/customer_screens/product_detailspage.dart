// import 'dart:ffi' hide Size;

import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart'
    as FlutterToast;
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/models/cartservice.dart';
import 'package:teaberryapp_project/models/customer_model.dart';

class ProductDetailspage extends StatefulWidget {
  final dynamic subproduct;
  final int? productId;

  const ProductDetailspage({
    super.key,
    required this.subproduct,
    this.productId,
  });
  @override
  _ProductDetailspageState createState() => _ProductDetailspageState();
}

class _ProductDetailspageState extends State<ProductDetailspage> {
  // int quantity = widget.subproduct.quantity ?? 0;
  String selectedSize = "14\"";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // int quantity = widget.subproduct.quantity ?? 0;Add commentMore actions
    final int maxQuantity = widget.subproduct.quantity ?? 0;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: const Color(0xffF5F6FA),
      backgroundColor: Color(0xFFF7F7F7),
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
          "Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            // fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      widget.subproduct.photoUrl != null
                          ? Image.network(
                            widget.subproduct.photoUrl!,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            'assets/iamges/coffee.jpg',
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Malviya Nagar Outlet",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                widget.subproduct.name ?? 'N/A',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Prosciutto e funghi is a pizza variety that is topped with tomato sauce.",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      SizedBox(width: 4),
                      Text(
                        "4.7",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(width: 18),
                  Row(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: Colors.orange,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Free",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(width: 18),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange, size: 18),
                      SizedBox(width: 4),
                      Text(
                        "20 min",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // // Size Options
            // const Text("SIZE:", style: TextStyle(fontWeight: FontWeight.bold)),
            // const SizedBox(height: 8),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children:
            //       [10, 14, 16].map((size) {
            //         bool isSelected = size == selectedSize;
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 8),
            //           child: ChoiceChip(
            //             label: Text('$size"'),
            //             selected: isSelected,
            //             onSelected: (_) {
            //               // setState(() => selectedSize = size);
            //             },
            //             selectedColor: const Color(0xffF6933F),
            //             backgroundColor: const Color(0xffE9ECF2),
            //             labelStyle: TextStyle(
            //               color: isSelected ? Colors.white : Colors.black,
            //             ),
            //           ),
            //         );
            //       }).toList(),
            // ),
            const Spacer(),

            // Bottom Price and Button Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: const BoxDecoration(
                color: const Color(0xffF5F6FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Price
                  Text(
                    "₹${widget.subproduct.price ?? 'N/A'}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),

                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff151a33),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--;
                            });
                          },
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              // quantity++;
                              if (quantity < maxQuantity)
                                quantity++;
                              else {
                                FlutterToast.showErrorToast(
                                  "Sorry, we don't have enough stock available.",
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Add to Cart Button pinned at bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 40, right: 16, left: 16),
        color: const Color(0xffF5F6FA),
        child: ElevatedButton(
          onPressed: () {
            // Add commentMore actions
            // Add to cart logic
            // CartService.clearCart();
            CartService.addItem(
              productId: widget.productId ?? 0, // Use 0 if productId is null
              subProductId: widget.subproduct.id!,
              quantity: quantity,
              price: widget.subproduct.price?.toDouble() ?? 0.0,
            );
            print("Current Item Added to Cart:");
            print({
              'productId': widget.productId ?? 0,
              'subProductId': widget.subproduct.id!,
              'quantity': quantity,
              'pricePerUnit': widget.subproduct.price?.toDouble() ?? 0.0,
            });
            print("Current Cart Items:");
            for (var item in CartService.items) {
              print(item);
            }
            FlutterToast.showAppToast("Added to cart");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff78AB4F),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("ADD TO CART", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

//     return Scaffold(
//       backgroundColor: Color(0xFFF7F7F7),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: CircleAvatar(
//             backgroundColor: Colors.white,
//             child: IconButton(
//               icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ),
//         title: Text(
//           "Details",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       // ...existing code...
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.only(bottom: 300), // Adjusted for floating bar
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child:
//                           widget.subproduct.photoUrl != null
//                               ? Image.network(
//                                 widget.subproduct.photoUrl!,
//                                 width: double.infinity,
//                                 height: 160,
//                                 fit: BoxFit.cover,
//                               )
//                               : Image.asset(
//                                 'assets/iamges/coffee.jpg',
//                                 width: double.infinity,
//                                 height: 160,
//                                 fit: BoxFit.cover,
//                               ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.location_on, color: Colors.red, size: 16),
//                           SizedBox(width: 4),
//                           Text(
//                             "Malviya Nagar Outlet",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 18),
//                   Text(
//                     widget.subproduct.name ?? 'N/A',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "Prosciutto e funghi is a pizza variety that is topped with tomato sauce.",
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                   const SizedBox(height: 18),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.star, color: Colors.orange, size: 18),
//                           SizedBox(width: 4),
//                           Text(
//                             "4.7",
//                             style: TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 18),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.delivery_dining,
//                             color: Colors.orange,
//                             size: 18,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             "Free",
//                             style: TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 18),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.access_time,
//                             color: Colors.orange,
//                             size: 18,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             "20 min",
//                             style: TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 22),
//                   Row(
//                     children: [
//                       Text(
//                         "SIZE:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       ...["10\"", "14\"", "16\""].map((size) {
//                         bool isSelected = selectedSize == size;
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedSize = size;
//                             });
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(right: 10),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                                   isSelected
//                                       ? Color(0xFFFFA726)
//                                       : Color(0xFFF2F2F2),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               size,
//                               style: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               padding: EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 18,
//                     offset: Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '₹${widget.subproduct.price?.toString() ?? '0'}',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(
//                                 Icons.remove,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   if (quantity > 1) quantity--;
//                                 });
//                               },
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0,
//                               ),
//                               child: Text(
//                                 '$quantity',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   if (quantity < maxQuantity)
//                                     quantity++;
//                                   else {
//                                     FlutterToast.showErrorToast(
//                                       "Sorry, we don't have enough stock available.",
//                                     );
//                                   }
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 18),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         CartService.addItem(
//                           productId: widget.productId ?? 0,
//                           subProductId: widget.subproduct.id!,
//                           quantity: quantity,
//                           price: widget.subproduct.price?.toDouble() ?? 0.0,
//                         );
//                         FlutterToast.showAppToast("Added to cart");
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Appcolors.green,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         "ADD TO CART",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.5,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // ...existing code...
