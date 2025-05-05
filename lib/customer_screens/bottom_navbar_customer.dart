import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/myprofile.screen.dart';
import 'package:teaberryapp_project/home_screen.dart';
import 'package:teaberryapp_project/walletrecgarge_screen.dart';

class BottomNavbarCustomer extends StatefulWidget {
  final index;
  const BottomNavbarCustomer({super.key, this.index});

  @override
  State<BottomNavbarCustomer> createState() => _BottomNavbarCustomerState();
}

class _BottomNavbarCustomerState extends State<BottomNavbarCustomer> {
  late int _index; // Declare _index without initialization

  final PageController _pageController = PageController(initialPage: 1);

  // Properly initialize the screen widgets
  final List<Widget> _screens = [
    WalletRechargeScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.index ?? 1; // Initialize _index in initState
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
            selectedItemColor: Appcolors.green, // ✅ Fix here
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              color: Appcolors.green,
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
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
              // BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.directions_car),
              //   label: 'Vehicles',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
