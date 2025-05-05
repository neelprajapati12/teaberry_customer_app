// import 'package:deliveryboy_screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:teaberryapp_project/deliveryboy_screens/homepage_deliveryboy.dart';

class NavigationbarDeliveryboy extends StatefulWidget {
  final index;
  const NavigationbarDeliveryboy({super.key, this.index});

  @override
  State<NavigationbarDeliveryboy> createState() =>
      _NavigationbarDeliveryboyState();
}

class _NavigationbarDeliveryboyState extends State<NavigationbarDeliveryboy> {
  late int _index; // Declare _index without initialization

  final PageController _pageController = PageController();

  // Properly initialize the screen widgets
  final List<Widget> _screens = [HomepageDeliveryboy()];

  @override
  void initState() {
    super.initState();
    _index = widget.index ?? 0; // Initialize _index in initState
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 220, 219, 219),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.green, // ✅ Fix here
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              color: Colors.green,
              fontSize: 13,
              fontFamily: "popR",
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontFamily: "popR",
            ),
            currentIndex: _index,
            onTap: (index) {
              setState(() {
                _index = index;
              });
              _pageController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.apartment),
                label: 'Company',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Admin',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_car),
                label: 'Vehicles',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
