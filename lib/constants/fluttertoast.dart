import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_colors.dart'; // Make sure this imports your Appcolors

void showAppToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 1,
    backgroundColor: Appcolors.maincolor,
    textColor: Colors.white,
    fontSize: 16.0,
    gravity: ToastGravity.BOTTOM, // You can change this if needed
    toastLength: Toast.LENGTH_SHORT,
  );
}

void showErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 1,
    backgroundColor: Appcolors.red,
    textColor: Colors.white,
    fontSize: 16.0,
    gravity: ToastGravity.BOTTOM, // You can change this if needed
    toastLength: Toast.LENGTH_SHORT,
  );
}
