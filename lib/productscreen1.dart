import 'package:flutter/material.dart';
import 'package:teaberryapp_project/productscreen2.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"name": "Chai", "image": "assets/iamges/chai.jpg"},
    {"name": "Coffee", "image": "assets/iamges/coffee.jpg"},
    {"name": "Pizza", "image": "assets/iamges/pizza.jpg"},

    {"name": "Sandwich", "image": "assets/iamges/sandwich.jpg"},
    {"name": "Sandwich", "image": "assets/iamges/sandwich.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.green),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("DELIVER TO", style: TextStyle(fontSize: 12, color: Colors.green)),
                            Text("Adam Doe office", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    Row(
                      children: [
                        const CircleAvatar(child: Text('A')),
                        Stack(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.notifications),
                            ),
                            Positioned(
                              right: 4,
                              top: 2,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 8,
                                child: Text('2', style: TextStyle(fontSize: 10, color: Colors.white)),
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
                const Text("Good Afternoon!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Delivery toggle
                Row(
                  children: [
                    ChoiceChip(label: Text("Delivery"), selected: true),
                    const SizedBox(width: 10),
                    ChoiceChip(label: Text("Take Away"), selected: false),
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
                  children: const [
                    Text("All Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("See All", style: TextStyle(color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 16),

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
                        if (item['name'] == 'Coffee') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CoffeeMenuScreen()),
                          );
                        }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}