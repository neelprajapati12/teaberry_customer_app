import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';

class ProfileScreenDeliveryboy extends StatefulWidget {
  @override
  State<ProfileScreenDeliveryboy> createState() =>
      _ProfileScreenDeliveryboyState();
}

class _ProfileScreenDeliveryboyState extends State<ProfileScreenDeliveryboy> {
  bool _isEditing = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  String? selectedStore;

  final TextEditingController nameController = TextEditingController(
    text: "Adam Doe",
  );
  final TextEditingController mobileController = TextEditingController(
    text: "+91 88888 34213",
  );
  final TextEditingController emailController = TextEditingController(
    text: "adam.doe@gmail.com",
  );
  final TextEditingController addressController = TextEditingController(
    text: "27-A, Aparna apartments, Gurudev..",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "********",
  );
  final TextEditingController confirmPasswordController = TextEditingController(
    text: "********",
  );

  final stores = ['Store 1', 'Store 2'];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Yellow Header with Back Button and Profile
          Container(
            color: Appcolors.yellow,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'You may edit your details here.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // White Container with Form
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
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
                    vSize(10),
                    Text("NAME"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: nameController,
                      enabled: _isEditing,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Adam Doe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("MOBILE NO"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: mobileController,
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "+91 88888 34213",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("EMAIL"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: emailController,
                      enabled: _isEditing,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "adam.doe@gmail.com",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
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
                          suffixIcon: Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.grey,
                          ),
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
                        onChanged:
                            _isEditing
                                ? (val) => setState(() => selectedStore = val)
                                : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("ADDRESS"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: addressController,
                      enabled: _isEditing,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "27-A, Aparna apartments, Gurudev..",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("PASSWORD"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: passwordController,
                      enabled: _isEditing,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 16,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _hidePassword = !_hidePassword,
                                  ),
                            ),
                            Icon(Icons.edit, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("RE-TYPE PASSWORD"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: confirmPasswordController,
                      enabled: _isEditing,
                      obscureText: _hideConfirmPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _hideConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 16,
                              ),
                              onPressed:
                                  () => setState(
                                    () =>
                                        _hideConfirmPassword =
                                            !_hideConfirmPassword,
                                  ),
                            ),
                            Icon(Icons.edit, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_isEditing) {
                            // Save changes logic here
                          }
                          _isEditing = !_isEditing;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isEditing ? "UPDATE" : "EDIT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    vSize(100),
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
