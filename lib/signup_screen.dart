import 'package:flutter/material.dart';
// import 'package:teaberryapp_project/bottom_navbar.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/customer_screens/bottom_navbar_customer.dart';
import 'package:teaberryapp_project/forgotpassword_screen.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedRole;
  String? selectedStore;

  final roles = ['Customer', 'Delivery Boy'];
  final stores = ['Store 1', 'Store 2'];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Yellow Header with Logo and Text
          Container(
            color: Appcolors.yellow,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/iamges/teaberry_logo.jpg',
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 15),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please sign up to get started',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),

          // Form Body
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSize(5),
                    Text("SIGN UP AS"),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        hint: Text("Please select"),
                        value: selectedRole,
                        items:
                            roles
                                .map(
                                  (role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => selectedRole = val),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("NAME"),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: nameController,
                      hintText: "Adam Doe",
                    ),
                    SizedBox(height: 20),
                    Text("MOBILE NO"),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: mobileController,
                      hintText: "+91 88888 34213",
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),
                    Text("EMAIL"),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "adam.doe@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    Text("NEAREST STORE"),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        hint: Text("Please select"),
                        value: selectedStore,
                        items:
                            stores
                                .map(
                                  (store) => DropdownMenuItem(
                                    value: store,
                                    child: Text(store),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => selectedStore = val),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("ADDRESS"),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: addressController,
                      hintText: "27-A, Aparna apartments, Gandhinagar...",
                    ),
                    SizedBox(height: 20),
                    Text("PASSWORD"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("RE-TYPE PASSWORD"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _hideConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Re-type Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hideConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    _hideConfirmPassword =
                                        !_hideConfirmPassword,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavbarCustomer(),
                          ),
                        );
                        // Add signup logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "LOG IN",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    vSize(20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
