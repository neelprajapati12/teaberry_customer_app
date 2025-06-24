import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:teaberryapp_project/constants/app_colors.dart';

import '../constants/api_constant.dart';

class SignupDeliveryBoy extends StatefulWidget {
  @override
  _SignupDeliveryBoyState createState() => _SignupDeliveryBoyState();
}

class _SignupDeliveryBoyState extends State<SignupDeliveryBoy> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  String? selectedStore;
  final stores = ['Store 1', 'Store 2'];

  File? _photoFile;
  File? _aadhaarFront;
  File? _aadhaarBack;

  Future<void> pickImage(Function(File) onPicked) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

  Future<void> registerDeliveryBoy() async {
    if (!_formKey.currentState!.validate()) return;

    final uri = Uri.parse('${ApiConstant.baseUrl}/auth/login');

    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = nameController.text.trim();
    request.fields['mobile'] = mobileController.text.trim();
    request.fields['email'] = emailController.text.trim();
    request.fields['address'] = addressController.text.trim();
    request.fields['store'] = selectedStore ?? '';

    if (_photoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _photoFile!.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    if (_aadhaarFront != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'aadhaar_front',
        _aadhaarFront!.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    if (_aadhaarBack != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'aadhaar_back',
        _aadhaarBack!.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registered successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              color: Appcolors.yellow,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  Image.asset('assets/iamges/removebckclr.png', height: 110),
                  SizedBox(height: 10),
                  Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text("Please sign up to get started", style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            Positioned(
              top: h * 0.32,
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
                      buildTextField("NAME", nameController),
                      buildTextField("MOBILE", mobileController, TextInputType.phone),
                      buildTextField("EMAIL", emailController, TextInputType.emailAddress),
                      SizedBox(height: 10),
                      Text("NEAREST STORE"),
                      storeDropdown(),
                      buildTextField("ADDRESS", addressController),
                      imageUploader("UPLOAD PHOTO", _photoFile, () => pickImage((f) => setState(() => _photoFile = f))),
                      imageUploader("AADHAAR FRONT", _aadhaarFront, () => pickImage((f) => setState(() => _aadhaarFront = f))),
                      imageUploader("AADHAAR BACK", _aadhaarBack, () => pickImage((f) => setState(() => _aadhaarBack = f))),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: registerDeliveryBoy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.green,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget buildTextField(String label, TextEditingController controller, [TextInputType type = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: type,
          validator: (val) => val == null || val.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ]),
    );
  }

  Widget storeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: selectedStore,
        hint: Text("Select Store"),
        items: stores.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (val) => setState(() => selectedStore = val),
        validator: (val) => val == null ? "Select a store" : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
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
                child: Text(file != null ? "Selected" : "No file chosen", style: TextStyle(color: Colors.black54)),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: onPick,
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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