import 'package:flutter/material.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
import 'package:teaberryapp_project/deliveryboy_screens/homepage_deliveryboy.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import 'package:teaberryapp_project/shared_pref.dart';

Widget getInitialPage() {
  if (SharedPreferencesHelper.getIsLoggedIn() == true) {
    final role = SharedPreferencesHelper.getRole();

    // if (role == "ROLE_SUPERADMIN") {
    //   return Bottomnavbar();
    // }
    if (role == "ROLE_CUSTOMER") {
      return BottomNavbarCustomer();
    } else if (role == "ROLE_DELIVERY_BOY") {
      return HomepageDeliveryboy();
    }
  }

  return LoginPage();
}
