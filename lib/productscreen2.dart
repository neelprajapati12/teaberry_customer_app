import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: CoffeeMenuScreen(),
//   ));
// }

class CoffeeMenuScreen extends StatelessWidget {
  final List<Map<String, String>> menuItems = [
    {
      "name": "Desi Filter Coffee",
      "image": "assets/iamges/coffee.jpg",
      "price": "40",
      "likes": "50.1k",
      "category": "Coffee"
    },
    {
      "name": "Cold Brew",
      "image": "assets/iamges/coffee.jpg",
      "price": "60",
      "likes": "20.5k",
      "category": "Coffee"
    },
    {
      "name": "Espresso",
      "image": "assets/iamges/coffee.jpg",
      "price": "55",
      "likes": "33.7k",
      "category": "Coffee"
    },
    {
      "name": "Cheesy Pizza",
      "image": "assets/iamges/pizza.jpg",
      "price": "120",
      "likes": "25.3k",
      "category": "Pizza"
    },
  ];

  final List<String> categories = ["Coffee", "Pizza", "Sandwich"];

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
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back),
                      const Text("Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Row(
                        children: const [
                          Icon(Icons.search),
                          SizedBox(width: 16),
                          Stack(
                            children: [
                              Icon(Icons.notifications_none),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.green,
                                  child: Text("2", style: TextStyle(fontSize: 10, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(categories[index]),
                            backgroundColor: index == 0 ? Colors.green : Colors.green.shade100,
                            labelStyle: TextStyle(
                              color: index == 0 ? Colors.white : Colors.green,
                            ),
                            avatar: index == 0
                                ? const Icon(Icons.local_cafe, color: Colors.white, size: 18)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return GestureDetector(
                          onTap: () {
                            if (item["category"] == "Pizza") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PizzaDetailsPage(
                                    name: item["name"]!,
                                    image: item["image"]!,
                                    price: item["price"]!,
                                    likes: item["likes"]!,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FoodDetailsPage(
                                    name: item["name"]!,
                                    image: item["image"]!,
                                    price: item["price"]!,
                                    likes: item["likes"]!,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item["image"]!,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item["name"]!,
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.favorite, size: 14, color: Colors.red),
                                          const SizedBox(width: 4),
                                          Text("Loved by ${item["likes"]}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text("₹${item["price"]}",
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating bottom bar
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "2 ITEMS ADDED; ₹295",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Coffee or general food item details page
class FoodDetailsPage extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final String likes;

  const FoodDetailsPage({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
    required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(image, height: 200),
            const SizedBox(height: 20),
            Text("Price: ₹$price", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Liked by: $likes", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to cart")),
                );
              },
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}

// Pizza details page
class PizzaDetailsPage extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final String likes;

  const PizzaDetailsPage({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
    required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(image, height: 200),
            const SizedBox(height: 20),
            Text("Price: ₹$price", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Liked by: $likes", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pizza added to cart")),
                );
              },
              child: const Text("Add Pizza to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}