import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';

// class SeeAllCategoriesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('All Categories')),
//       body: Center(
//         child: Text(
//           'This is the All Categories page.',
//           style: TextStyle(fontSize: 25),
//         ),
//       ),
//     );
//   }
// }

class SeeAllCategoriesPage extends StatefulWidget {
  @override
  State<SeeAllCategoriesPage> createState() => _SeeAllCategoriesPageState();
}

class _SeeAllCategoriesPageState extends State<SeeAllCategoriesPage> {
  final List<Map<String, dynamic>> coffeeItems = List.generate(
    3,
    (index) => {
      'name': 'Desi Filter Coffee',
      'likedBy': '50.1k',
      'price': 40,
      'image': 'https://i.imgur.com/3x0S9kD.jpg',
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOfferDialog(context);
    });
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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Menu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 28, color: Colors.black),
              Positioned(
                top: 8,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Appcolors.green,
                  radius: 8,
                  child: Text(
                    '2',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       CircleAvatar(
            //         backgroundColor: Colors.grey[200],
            //         child: Icon(Icons.arrow_back, color: Colors.black),
            //       ),
            //       Text(
            //         'Menu',
            //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            //       ),
            //       Row(
            //         children: [
            //           Icon(Icons.search, color: Colors.black),
            //           SizedBox(width: 16),
            //           Stack(
            //             children: [
            //               Icon(Icons.shopping_cart_outlined, size: 28),
            //               Positioned(
            //                 top: 0,
            //                 right: 0,
            //                 child: CircleAvatar(
            //                   backgroundColor: Appcolors.green,
            //                   radius: 8,
            //                   child: Text(
            //                     '2',
            //                     style: TextStyle(
            //                       fontSize: 10,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            // Category Chips
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryChip(
                    label: "Coffee",
                    icon: Icons.local_cafe,
                    selected: true,
                  ),
                  CategoryChip(label: "Pizza", icon: Icons.local_pizza),
                  CategoryChip(label: "Sandwich", icon: Icons.fastfood),
                ],
              ),
            ),

            // Coffee Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Coffee (6)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Product List
            Expanded(
              child: ListView.builder(
                itemCount: coffeeItems.length,
                itemBuilder: (context, index) {
                  var item = coffeeItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/iamges/coffee.jpg',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '❤️ Loved By ${item['likedBy']}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${item['price']}',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(
                                        Icons.add_circle,
                                        color: Appcolors.green,
                                        size: 28,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Cart Bar
            Container(
              width: double.infinity,
              height: h * 0.065,
              padding: EdgeInsets.all(14),
              color: Appcolors.green.withOpacity(0.9),
              child: Center(
                child: Text(
                  '2 ITEMS ADDED; ₹295',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                      onTap: () => Navigator.pop(context),
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

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const CategoryChip({
    required this.label,
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Chip(
        avatar: Icon(
          icon,
          color: selected ? Colors.white : Appcolors.green,
          size: 18,
        ),
        label: Text(label),
        backgroundColor: selected ? Appcolors.green : Colors.green[100],
        labelStyle: TextStyle(color: selected ? Colors.white : Appcolors.green),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
