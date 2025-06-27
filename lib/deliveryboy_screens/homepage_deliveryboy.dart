import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/deliveryboy_screens/myprofile_screen_deliveryboy.dart';
import 'package:teaberryapp_project/deliveryboy_screens/order_screen.dart';
import 'package:teaberryapp_project/models/deliveryordermodel.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class HomepageDeliveryboy extends StatefulWidget {
  @override
  State<HomepageDeliveryboy> createState() => _HomepageDeliveryboyState();
}

class _HomepageDeliveryboyState extends State<HomepageDeliveryboy> {
  List<DeliveryOrderModel> orders = [];
  bool isLoading = true;
  dynamic orderdata;
  dynamic incentive;
  dynamic profiledata;

  Future<void> fetchAllDeliveries() async {
    final url = Uri.parse(
      '${ApiConstant.baseUrl}/deliveries/boy/${SharedPreferencesHelper.getIDdeliveryboy()}',
    );
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
      },
    );

    if (response.statusCode == 200) {
      print("Deliveries Fetched - ${response.body}");
      print("Deliveries fetched successfully");
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        orders =
            data
                .where((json) => json['status'] != 'DELIVERED')
                .map(
                  (json) =>
                      DeliveryOrderModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load deliveries');
    }
  }

  login() async {
    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/auth/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "mobile": SharedPreferencesHelper.getdeliveryboymobno(),
        "password": SharedPreferencesHelper.getdeliveryboypassword(),
      });
      print("Body" + body);

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Login Successfully");
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

  getorderdata() async {
    final url = Uri.parse('${ApiConstant.baseUrl}/deliveries/delivery-boys');
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
      },
    );

    if (response.statusCode == 200) {
      print("Order Data Fetched - ${response.body}");
      print("Order data fetched successfully");
      orderdata = json.decode(response.body);
      setState(() {});
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load orders data');
    }
  }

  getincentivedata() async {
    final url = Uri.parse(
      '${ApiConstant.baseUrl}/api/incentives/delivery-boy/${SharedPreferencesHelper.getIDdeliveryboy()}',
    );
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
      },
    );

    if (response.statusCode == 200) {
      print("Incentive Data Fetched - ${response.body}");
      print("Incentive data fetched successfully");
      incentive = json.decode(response.body);
      setState(() {});
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load inentives');
    }
  }

  getprofile() async {
    final url = Uri.parse('${ApiConstant.baseUrl}/auth/profile');
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
      },
    );

    if (response.statusCode == 200) {
      print("Profile Data Fetched - ${response.body}");
      print("Profile fetched successfully");
      profiledata = json.decode(response.body);
      setState(() {});
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load Profile');
    }
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
  void initState() {
    super.initState();
    login();
    fetchAllDeliveries();
    getorderdata();
    getincentivedata();
    getprofile();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    String firstChar =
        profiledata != null && profiledata["name"] != null
            ? profiledata["name"].toUpperCase().substring(0, 1)
            : "";
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          orders.isEmpty && isLoading
              ? Center(child: CircularProgressIndicator())
              : orderdata.isEmpty
              ? CircularProgressIndicator()
              : incentive.isEmpty
              ? CircularProgressIndicator()
              : profiledata.isEmpty
              ? CircularProgressIndicator()
              : SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Initial
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProfileScreenDeliveryboy(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Text(
                                firstChar,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          // Logo
                          Column(
                            children: [
                              Image.asset(
                                'assets/iamges/removebckclr.png',
                                // width: w * 0.3,
                                height: h * 0.2,
                              ),
                              // Text(
                              //   'Tea berry',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                              // Text(
                              //   'Feel fresh',
                              //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              // ),
                            ],
                          ),
                          // Notification Icon
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => OrdersScreen(
                                        orders: orders,
                                        firstchar: firstChar,
                                      ),
                                ),
                              ).then((_) {
                                // Called when coming back from the product details page
                                setState(() {});
                              });
                            },
                            child: Stack(
                              children: [
                                Icon(Icons.notifications_outlined, size: 28),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF76A04D),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      "${orders.length}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // SizedBox(height: 5),

                      // Welcome Text
                      Text(
                        'Hey ${profiledata["name"]}, ${timeoftheday()}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 24),

                      // Profile Section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber[300],
                            backgroundImage: AssetImage(
                              'assets/iamges/user.png',
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${profiledata["name"]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${profiledata["email"]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '${profiledata["mobile"]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      // Stats Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFF76A04D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'You\'ve completed ${orderdata[0]["monthlyDeliveryQuantity"]} deliveries\nthis month!\nKeep it up!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Today\'s Orders: ${orderdata[0]["todayDeliveryQuantity"]}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'This Month\'s Orders: ${orderdata[0]["todayDeliveryQuantity"]}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: w * 0.8,
                              child: Text(
                                'Total Bonus This Month: Rs. ${incentive["incentiveAmount"]}/-',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
