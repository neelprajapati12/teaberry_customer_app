import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/customer_screens/mycart_screen.dart';
import 'package:teaberryapp_project/customer_screens/product_detailspage.dart';
import 'package:teaberryapp_project/customer_screens/searchpage.dart';
import 'package:teaberryapp_project/models/cartservice.dart';
import 'package:teaberryapp_project/models/customer_model.dart';

class SeeAllCategoriesPage extends StatefulWidget {
  final List<Inventories> product;
  final CustomerModel customerData;
  final index;

  const SeeAllCategoriesPage({
    super.key,
    required this.product,
    this.index,
    required this.customerData,
  });
  @override
  State<SeeAllCategoriesPage> createState() => _SeeAllCategoriesPageState();
}

class _SeeAllCategoriesPageState extends State<SeeAllCategoriesPage> {
  late int selectedIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.index ?? 0;
    print(CartService.totalPrice);
    print(CartService.items.length);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showOfferDialog(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // int selectedIndex = widget.index ?? 0;
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
            // fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          SearchScreen(customerData: widget.customerData),
                ),
              );
            },
            child: Icon(Icons.search, color: Colors.black, size: 28),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                  color: Colors.black,
                ),
                Positioned(
                  top: 8,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Appcolors.green,
                    radius: 8,
                    child: Text(
                      '${CartService.items.length}',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.length,
              itemBuilder: (context, index) {
                return CategoryChip(
                  label: widget.product[index].name ?? 'Unknown',
                  selected:
                      index == selectedIndex, // This will now work correctly
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      print(
                        'Selected category: ${widget.product[index].name}',
                      ); // Debug print
                    });
                  },
                );
              },
            ),
          ),

          // Coffee Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  "${widget.product[selectedIndex].name} (${widget.product[selectedIndex].subProducts!.length})",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: widget.product[selectedIndex].subProducts!.length,
              itemBuilder: (context, index) {
                final subProduct =
                    widget.product[selectedIndex].subProducts![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductDetailspage(
                                storelocation:
                                    widget.customerData.store!.location,
                                subproduct: subProduct,
                                productId: widget.product[selectedIndex].id!,
                              ),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
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
                              child:
                                  subProduct.photoUrl != null
                                      ? Image.network(
                                        subProduct.photoUrl!,
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subProduct.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '❤️ Loved By ${(50 + index).toString()}k', // Dynamic count
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹${subProduct.price}',
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // Icon(
                                      //   Icons.add_circle,
                                      //   color: Appcolors.green,
                                      //   size: 28,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Cart Bar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CartPage(
                        customeraddress: widget.customerData.address,
                      ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            child: Container(
              width: double.infinity,
              height: h * 0.09,
              padding: EdgeInsets.all(14),
              color: Appcolors.green.withOpacity(0.9),
              child: Center(
                child: Text(
                  '${CartService.items.length} ITEMS ADDED; ₹${CartService.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Update the CategoryChip class
class CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(label),
          backgroundColor: selected ? Appcolors.green : Colors.green[100],
          labelStyle: TextStyle(
            color: selected ? Colors.white : Appcolors.green,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
