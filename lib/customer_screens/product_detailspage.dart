import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/models/customer_model.dart';

class ProductDetailspage extends StatefulWidget {
  final SubProducts1 subproduct;

  const ProductDetailspage({super.key, required this.subproduct});
  @override
  _ProductDetailspageState createState() => _ProductDetailspageState();
}

class _ProductDetailspageState extends State<ProductDetailspage> {
  // int quantity = widget.subproduct.quantity ?? 0;
  String selectedSize = "14\"";

  @override
  Widget build(BuildContext context) {
    int quantity = widget.subproduct.quantity ?? 0;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.subproduct.name ?? 'Product Details'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: 250,
              ), // add bottom padding to avoid overlap
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Icon(Icons.arrow_back_ios),
                    //     SizedBox(width: 8),
                    //     Text(
                    //       "Details",
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          widget.subproduct.photoUrl != null
                              ? Image.network(
                                widget.subproduct.photoUrl!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                'assets/iamges/coffee.jpg',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text("Malviya Nagar Outlet"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.subproduct.name ?? 'N/A',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Prosciutto e funghi is a pizza variety that is topped with tomato sauce.",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            SizedBox(width: 4),
                            Text("4.7"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.delivery_dining, color: Colors.orange),
                            SizedBox(width: 4),
                            Text("Free"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.orange),
                            SizedBox(width: 4),
                            Text("20 min"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Text(
                    //   "SIZE:",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 10),
                    // Row(
                    //   children:
                    //       ["10\"", "14\"", "16\""].map((size) {
                    //         bool isSelected = selectedSize == size;
                    //         return GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               selectedSize = size;
                    //             });
                    //           },
                    //           child: Container(
                    //             margin: EdgeInsets.only(right: 12),
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: 16,
                    //               vertical: 8,
                    //             ),
                    //             decoration: BoxDecoration(
                    //               color:
                    //                   isSelected
                    //                       ? Colors.orange
                    //                       : Colors.grey[200],
                    //               borderRadius: BorderRadius.circular(20),
                    //             ),
                    //             child: Text(
                    //               size,
                    //               style: TextStyle(
                    //                 color:
                    //                     isSelected
                    //                         ? Colors.white
                    //                         : Colors.black,
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       }).toList(),
                    // ),
                    const SizedBox(height: 30),

                    // Replace the bottom Container and ElevatedButton with this code
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${widget.subproduct.price?.toString() ?? '0'}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                MaterialButton(
                                  minWidth: 40,
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 1) quantity--;
                                    });
                                  },
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    '$quantity',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  minWidth: 40,
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Add to cart logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "ADD TO CART",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
