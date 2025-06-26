import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/myprofile.screen_customer.dart';
import 'package:teaberryapp_project/customer_screens/product_detailspage.dart';
import 'package:teaberryapp_project/customer_screens/see_all_categories_page.dart';
import 'package:teaberryapp_project/models/customer_model.dart';
import 'package:teaberryapp_project/models/homepage_model.dart';
import 'package:teaberryapp_project/shared_pref.dart';
// import 'package:teaberryapp_project/myprofile.screen.dart';
// import 'package:teaberryapp_project/product_detailspage.dart';
// import 'package:teaberryapp_project/see_all_categories_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String deliveryOption = "Delivery";

  final List<Map<String, String>> categories = [
    {"name": "Chai", "image": "assets/iamges/chai.jpg"},
    {"name": "Coffee", "image": "assets/iamges/coffee.jpg"},
    {"name": "Pizza", "image": "assets/iamges/pizza.jpg"},
    {"name": "Sandwich", "image": "assets/iamges/sandwich.jpg"},
  ];

  // List<dynamic> products = [];
  bool isLoading = true;
  String error = '';

  // Update these class variables
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

  login() async {
    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/auth/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "mobile": SharedPreferencesHelper.getcustomermobno(),
        "password": SharedPreferencesHelper.getcustomerpassword(),
      });
      print("Body" + body);

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'];
        SharedPreferencesHelper.setTokencustomer(apiKey: token);
        print("Logged in as ${SharedPreferencesHelper.getRole()}");
      } else {
        print("Login failed: ${response.body}");
      }
    } catch (e) {
      print("Login exception: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    login();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSize(30),
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Appcolors.green),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "DELIVER TO",
                            style: TextStyle(
                              fontSize: 12,
                              color: Appcolors.green,
                            ),
                          ),
                          Text(
                            "Adam Doe office",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreenCustomer(),
                            ),
                          );
                        },
                        child: const CircleAvatar(child: Text('A')),
                      ),
                      Stack(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(Icons.notifications),
                          ),
                          Positioned(
                            right: 4,
                            top: 1,
                            child: CircleAvatar(
                              backgroundColor: Appcolors.green,
                              radius: 8,
                              child: Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Greeting
              const Text("Hey Adam,", style: TextStyle(fontSize: 20)),
              const Text(
                "Good Afternoon!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Delivery Toggle as Radio Buttons
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text("Delivery"),
                      value: "Delivery",
                      groupValue: deliveryOption,
                      activeColor: Appcolors.green,
                      onChanged: (value) {
                        setState(() {
                          deliveryOption = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text("Take Away"),
                      value: "Take Away",
                      groupValue: deliveryOption,
                      activeColor: Appcolors.green,
                      onChanged: (value) {
                        setState(() {
                          deliveryOption = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search dishes, restaurants",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     // Navigator.push(
                  //     //   context,
                  //     //   MaterialPageRoute(
                  //     //     builder: (context) => SeeAllCategoriesPage(),
                  //     //   ),
                  //     // );
                  //   },
                  //   child: Text(
                  //     "See All",
                  //     style: TextStyle(
                  //       color: Appcolors.green,
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              // Categories Grid
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 2.5,
                ),
                itemBuilder: (context, index) {
                  // final item = categories[index];
                  // final product = products[index];
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      // if (item['name'] == 'Coffee') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SeeAllCategoriesPage(product: products),
                        ),
                      );
                      // }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image:
                              product.photoUrl != null
                                  ? NetworkImage(product.photoUrl!)
                                  : AssetImage('assets/iamges/chai.jpg')
                                      as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.2),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name ?? 'Unknown Product',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              vSize(20),
            ],
          ),
        ),
      ),
    );
  }
}
