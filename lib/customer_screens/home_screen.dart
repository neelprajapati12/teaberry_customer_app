import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/myprofile.screen.dart';
import 'package:teaberryapp_project/product_detailspage.dart';
import 'package:teaberryapp_project/see_all_categories_page.dart';

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
                              builder: (context) => ProfileScreen(),
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeAllCategoriesPage(),
                        ),
                      );
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: Appcolors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              // Categories Grid
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 2.5,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // if (item['name'] == 'Coffee') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailspage(),
                        ),
                      );
                      // }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(item["image"]!),
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
                            item["name"]!,
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
