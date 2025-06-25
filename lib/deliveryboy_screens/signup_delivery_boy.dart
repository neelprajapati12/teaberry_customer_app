import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import '../constants/api_constant.dart';

class SignupDeliveryBoy extends StatefulWidget {
  @override
  _SignupDeliveryBoyState createState() => _SignupDeliveryBoyState();
}

class _SignupDeliveryBoyState extends State<SignupDeliveryBoy> {
  bool _hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedStore;
  final stores = ['Store 1', 'Store 2'];

  File? _photoFile;
  File? _aadhaarFront;
  File? _aadhaarBack;

  Future<void> pickImage(Function(File) onPicked) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

  Future<void> _uploadImage(Function(File) onPicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png', 'jpg'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      onPicked(file);

      // Optional: Save locally if needed
      // await SharedPreferencesHelper.setUserImage(file);
      showAppToast("Image Uploaded Successfully!");
      // Fluttertoast.showToast(
      //   msg: "Image Selected Successfully!",
      //   backgroundColor: Color(0xffFFDFDF),
      //   textColor: Appcolors.red,
      // );
    }
  }

  Future<void> registerDeliveryBoy() async {
    if (!_formKey.currentState!.validate()) return;

    if (_photoFile == null || _aadhaarFront == null || _aadhaarBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload photo, Aadhaar front and back")),
      );
      return;
    }

    final dio = Dio();

    final userData = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": mobileController.text.trim(),
      "password": passwordController.text.trim(),
      "role": "ROLE_DELIVERY_BOY",
      "storeId": selectedStore == 'Store 1' ? 1 : 2,
    };

    try {
      final formData = FormData.fromMap({
        'userData': MultipartFile.fromString(
          json.encode(userData),
          contentType: MediaType("application", "json"),
        ),
        'photo': await MultipartFile.fromFile(
          _photoFile!.path,
          filename: _photoFile!.path.split('/').last,
        ),
        'aadharFront': await MultipartFile.fromFile(
          _aadhaarFront!.path,
          filename: _aadhaarFront!.path.split('/').last,
        ),
        'aadharBack': await MultipartFile.fromFile(
          _aadhaarBack!.path,
          filename: _aadhaarBack!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        "${ApiConstant.baseUrl}/auth/signup",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        showAppToast(response.data['message'] ?? "Registered successfully");
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text("Registered successfully")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        showErrorToast(
          "Registration failed: ${response.data['error'] ?? response.statusMessage}",
        );
      }
    } catch (e) {
      print("Dio error: $e");
      showErrorToast("Something went wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.yellow,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              color: Appcolors.yellow,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: IconButton(
                  //         icon: Icon(
                  //           Icons.arrow_back,
                  //           color: Colors.black,
                  //           size: 20,
                  //         ),
                  //         onPressed: () => Navigator.pop(context),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Image.asset(
                    'assets/iamges/removebckclr.png',
                    fit: BoxFit.fill,
                    height: 160,
                    width: 200,
                  ),
                  // SizedBox(height: 5),
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
            Positioned(
              top: h * 0.29,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextField(
                        "NAME",
                        nameController,
                        hinttext: "Adam Doe",
                      ),
                      buildTextField(
                        "MOBILE",
                        mobileController,
                        type: TextInputType.phone,
                        hinttext: "+91 88888 34213",
                      ),
                      buildTextField(
                        "EMAIL",
                        emailController,
                        type: TextInputType.emailAddress,
                        hinttext: "example@gmail.com",
                      ),
                      SizedBox(height: 10),
                      Text("NEAREST STORE"),
                      storeDropdown(),
                      buildTextField(
                        "ADDRESS",
                        addressController,
                        hinttext: "27-A, Aparna apartments, Gandhinagar...",
                      ),
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
                      // Upload PHOTO
                      imageUploader(
                        "UPLOAD PHOTO",
                        _photoFile,
                        () =>
                            _uploadImage((f) => setState(() => _photoFile = f)),
                      ),

                      // Upload AADHAAR FRONT
                      imageUploader(
                        "AADHAAR FRONT",
                        _aadhaarFront,
                        () => _uploadImage(
                          (f) => setState(() => _aadhaarFront = f),
                        ),
                      ),

                      // Upload AADHAAR BACK
                      imageUploader(
                        "AADHAAR BACK",
                        _aadhaarBack,
                        () => _uploadImage(
                          (f) => setState(() => _aadhaarBack = f),
                        ),
                      ),

                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: registerDeliveryBoy,
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool isPassword = false,
    required String hinttext,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: type,
            obscureText: isPassword,
            validator: (val) => val == null || val.isEmpty ? "Required" : null,
            decoration: InputDecoration(
              hintText: hinttext,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget storeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: selectedStore,
        hint: Text("Select Store"),
        items:
            stores
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
        onChanged: (val) => setState(() => selectedStore = val),
        validator: (val) => val == null ? "Select a store" : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget imageUploader(String label, File? file, VoidCallback onPick) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  file != null ? "Selected" : "No file chosen",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: onPick,
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("UPLOAD", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
