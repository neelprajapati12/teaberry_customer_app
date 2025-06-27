import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import '../constants/api_constant.dart';

class ProfileScreenDeliveryboy extends StatefulWidget {
  @override
  State<ProfileScreenDeliveryboy> createState() => _ProfileScreenDeliveryboyState();
}

class _ProfileScreenDeliveryboyState extends State<ProfileScreenDeliveryboy> {
  final Dio dio = Dio();
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  File? _photoFile;
  File? _aadhaarFrontFile;
  File? _aadhaarBackFile;
  String? token;

  @override
  void initState() {
    super.initState();
    loadTokenAndFetchProfile();
  }

  Future<void> loadTokenAndFetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    if (token != null) {
      fetchProfile();
    } else {
      print("Token not found");
    }
  }

  Future<void> fetchProfile() async {
    try {
      final response = await dio.get(
        "${ApiConstant.baseUrl}/auth/profile",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          mobileController.text = data['mobile'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  Future<void> pickImage(Function(File) onPicked) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

  Future<void> updateProfile() async {
    try {
      final userData = {
        "name": nameController.text,
        "email": emailController.text,
        "mobile": mobileController.text,
      };

      FormData formData = FormData.fromMap({
        "userData": jsonEncode(userData),
        if (_photoFile != null)
          "photo": await MultipartFile.fromFile(_photoFile!.path),
        if (_aadhaarFrontFile != null)
          "aadharFront": await MultipartFile.fromFile(_aadhaarFrontFile!.path),
        if (_aadhaarBackFile != null)
          "aadharBack": await MultipartFile.fromFile(_aadhaarBackFile!.path),
      });

      final response = await dio.put(
        "${ApiConstant.baseUrl}/auth/update-profile",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
        fetchProfile();
      }
    } catch (e) {
      print("Update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: Appcolors.yellow,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                vSize(20),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Colors.grey)),
                      vSize(15),
                      Text('My Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                      vSize(8),
                      Text('You may edit your details here.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
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
                    formField("NAME", nameController),
                    formField("MOBILE NO", mobileController),
                    formField("EMAIL", emailController),
                    imageRow("UPLOAD PHOTOGRAPH", () => pickImage((f) => setState(() => _photoFile = f))),
                    vSize(20),
                    Text("UPLOAD AADHAAR CARD"),
                    vSize(10),
                    aadhaarRow(),
                    vSize(20),
                    Row(
                      children: [
                        expandedUploadBtn(() => pickImage((f) => setState(() => _aadhaarFrontFile = f))),
                        hSize(10),
                        expandedUploadBtn(() => pickImage((f) => setState(() => _aadhaarBackFile = f))),
                      ],
                    ),
                    vSize(30),
                    ElevatedButton(
                      onPressed: updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("UPDATE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget formField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        vSize(5),
        TextFormField(
          controller: controller,
          enabled: enabled && _isEditing,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            suffixIcon: Icon(Icons.edit, size: 16, color: Colors.grey),
          ),
        ),
        vSize(20),
      ],
    );
  }

  Widget imageRow(String label, VoidCallback onUpload) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        vSize(5),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Text("No file chosen", style: TextStyle(color: Colors.black54)),
              ),
            ),
            hSize(10),
            ElevatedButton(
              onPressed: onUpload,
              style: ElevatedButton.styleFrom(backgroundColor: Appcolors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text("UPLOAD", style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }

  Widget aadhaarRow() {
    return Row(
      children: [
        Expanded(child: aadhaarCardField("FRONT SIDE")),
        hSize(10),
        Expanded(child: aadhaarCardField("BACK SIDE")),
      ],
    );
  }

  Widget aadhaarCardField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12)),
        vSize(5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("SELECT", style: TextStyle(color: Colors.black54)), Icon(Icons.arrow_drop_down, color: Colors.black54)],
          ),
        ),
      ],
    );
  }

  Widget expandedUploadBtn(VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Appcolors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text("UPLOAD", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}