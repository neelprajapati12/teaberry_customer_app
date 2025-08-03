import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
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
            fontSize: ResponsiveSize.font(context, 4.5),
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
              ).then((_) {
                setState(() {});
              });
            },
            child: Icon(
              Icons.search,
              color: Colors.black,
              size: ResponsiveSize.width(context, 7),
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 5)),
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: ResponsiveSize.width(context, 7),
                  color: Colors.black,
                ),
                Positioned(
                  top: ResponsiveSize.height(context, 1),
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Appcolors.green,
                    radius: ResponsiveSize.width(context, 2),
                    child: Text(
                      '${CartService.items.length}',
                      style: TextStyle(
                        fontSize: ResponsiveSize.font(context, 2.5),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 4)),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: ResponsiveSize.height(context, 5),
            margin: EdgeInsets.symmetric(
              vertical: ResponsiveSize.height(context, 1),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 3),
            ),
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
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 4),
            ),
            child: Row(
              children: [
                Text(
                  "${widget.product[selectedIndex].name} (${widget.product[selectedIndex].subProducts!.length})",
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(context, 4.5),
                    fontWeight: FontWeight.bold,
                  ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.width(context, 4),
                    vertical: ResponsiveSize.height(context, 1),
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
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.width(context, 3),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          ResponsiveSize.width(context, 2),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.width(context, 3),
                              ),
                              child:
                                  subProduct.photoUrl != null
                                      ? Image.network(
                                        subProduct.photoUrl!,
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
                            SizedBox(width: ResponsiveSize.width(context, 3)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subProduct.name!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveSize.font(context, 4),
                                    ),
                                  ),
                                  SizedBox(
                                    height: ResponsiveSize.height(context, 0.8),
                                  ),
                                  Text(
                                    '❤️ Loved By ${(50 + index).toString()}k', // Dynamic count
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.font(context, 3),
                                    ),
                                  ),
                                  SizedBox(
                                    height: ResponsiveSize.height(context, 1.2),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹${subProduct.price}',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.font(
                                            context,
                                            6,
                                          ),
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
          SafeArea(
            child: GestureDetector(
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
                height: ResponsiveSize.height(context, 8),
                padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
                margin: EdgeInsets.all(ResponsiveSize.width(context, 2)),
                decoration: BoxDecoration(
                  color: Appcolors.green.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.width(context, 3),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${CartService.items.length} ITEMS ADDED; ₹${CartService.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(context, 4.5),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
        padding: EdgeInsets.only(right: ResponsiveSize.width(context, 2)),
        child: Chip(
          label: Text(label),
          backgroundColor: selected ? Appcolors.green : Colors.green[100],
          labelStyle: TextStyle(
            color: selected ? Colors.white : Appcolors.green,
            fontSize: ResponsiveSize.font(context, 3.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveSize.width(context, 3),
            ),
          ),
        ),
      ),
    );
  }
}
