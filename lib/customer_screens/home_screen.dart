import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/responsivesize.dart';
import 'package:teaberryapp_project/customer_screens/myprofile.screen_customer.dart';
import 'package:teaberryapp_project/customer_screens/product_detailspage.dart';
import 'package:teaberryapp_project/customer_screens/searchpage.dart';
import 'package:teaberryapp_project/customer_screens/see_all_categories_page.dart';
import 'package:teaberryapp_project/customer_screens/wallet_screen.dart';
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
  dynamic profiledata;

  // Update these class variables
  List<Inventories> products = [];

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
                inventories.map((json) => Inventories.fromJson(json)).toList();
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
        SharedPreferencesHelper.setTokendeliveryboy(apiKey: token);
        print("Logged in as ${SharedPreferencesHelper.getRole()}");
      } else {
        print("Login failed: ${response.body}");
      }
    } catch (e) {
      print("Login exception: $e");
    }
  }

  CustomerModel? customerModel;

  Future<void> getprofile() async {
    final url = Uri.parse('${ApiConstant.baseUrl}/auth/profile');
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
      },
    );

    if (response.statusCode == 200) {
      SharedPreferencesHelper.setcustomerwalletbalance(
        walletbalance: json.decode(response.body)['walletBalance'].toString(),
      );
      print(
        'Wallet Balance: ${SharedPreferencesHelper.getcustomerwalletbalance()}',
      );
      print("Profile Data Fetched - ${response.body}");
      print("Profile fetched successfully");
      final decoded = json.decode(response.body);
      profiledata = decoded;
      customerModel = CustomerModel.fromJson(decoded);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        error = 'Failed to load Profile';
      });
      print('Failed to load Profile: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    login();
    fetchProducts();
    getprofile();
  }

  timeoftheday() {
    if (DateTime.now().hour < 12) {
      return "Good Morning!";
    } else if (DateTime.now().hour < 17) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          profiledata == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 6),
                  vertical: ResponsiveSize.height(context, 2.5),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveSize.height(context, 5)),
                      // Top Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Appcolors.green,
                              ),
                              const SizedBox(width: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DELIVER TO",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Appcolors.green,
                                    ),
                                  ),
                                  Text(
                                    profiledata['address'] ?? 'Your Address',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                          Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder:
                              //             (context) => ProfileScreenCustomer(),
                              //       ),
                              //     );
                              //   },
                              //   child: CircleAvatar(
                              //     backgroundColor: Colors.grey.shade200,
                              //     child: Text(
                              //       firstChar,
                              //       style: TextStyle(color: Appcolors.green),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(width: ResponsiveSize.width(context, 3)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WalletScreen(),
                                    ),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.wallet,
                                    color: Appcolors.green,
                                  ),
                                ),
                              ),

                              // Stack(
                              //   children: const [
                              //     Padding(
                              //       padding: EdgeInsets.only(left: 4.0),
                              //       child: Icon(Icons.notifications),
                              //     ),
                              //     Positioned(
                              //       right: 4,
                              //       top: 1,
                              //       child: CircleAvatar(
                              //         backgroundColor: Appcolors.green,
                              //         radius: 8,
                              //         child: Text(
                              //           '0',
                              //           style: TextStyle(
                              //             fontSize: 10,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveSize.height(context, 2.5),
                      ), // was 20
                      // Greeting
                      Text(
                        "Hey ${profiledata["name"]},",
                        style: TextStyle(
                          fontSize: ResponsiveSize.font(context, 5),
                        ),
                      ),
                      Text(
                        timeoftheday(),
                        style: TextStyle(
                          fontSize: ResponsiveSize.font(context, 5.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveSize.height(context, 2.5),
                      ), // was 16
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
                      SizedBox(
                        height: ResponsiveSize.height(context, 2.5),
                      ), // was 16
                      // Search Bar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SearchScreen(
                                    customerData: customerModel!,
                                  ),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.width(context, 3),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.width(context, 3),
                            ),
                            color: Colors.grey.shade200,
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              icon: Icon(Icons.search),
                              hintText: "Search dishes, restaurants",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveSize.height(context, 3),
                      ), // was 24
                      // Categories Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "All Categories",
                            style: TextStyle(
                              fontSize: ResponsiveSize.font(context, 5),
                              fontWeight: FontWeight.bold,
                            ),
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
                      // In the GridView.builder section, update the itemBuilder:
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: ResponsiveSize.width(context, 4),
                          crossAxisSpacing: ResponsiveSize.width(context, 4),
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SeeAllCategoriesPage(
                                        customerData: customerModel!,
                                        product: products,
                                        index: index,
                                      ),
                                ),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveSize.width(context, 3),
                                      ),
                                      image: DecorationImage(
                                        image:
                                            product.photoUrl != null
                                                ? NetworkImage(
                                                  product.photoUrl!,
                                                )
                                                : AssetImage(
                                                      'assets/iamges/chai.jpg',
                                                    )
                                                    as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: ResponsiveSize.height(context, 1.5),
                                ),
                                Text(
                                  product.name ?? 'Unknown Product',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveSize.font(context, 4),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 2.5)),
                    ],
                  ),
                ),
              ),
    );
  }
}
