import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/fluttertoast.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/login_customerscreen.dart';
import 'package:teaberryapp_project/models/customer_model.dart';
import 'package:teaberryapp_project/shared_pref.dart';
import '../constants/api_constant.dart';

class ProfileScreenDeliveryboy extends StatefulWidget {
  @override
  State<ProfileScreenDeliveryboy> createState() =>
      _ProfileScreenDeliveryboyState();
}

class _ProfileScreenDeliveryboyState extends State<ProfileScreenDeliveryboy> {
  final Dio dio = Dio();
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading = true;
  String error = '';

  List<CustomerModel> profile = [];

  Future<void> fetchProfile() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      print('Fetching products from: ${ApiConstant.baseUrl}/auth/profile');
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
        },
      );

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Profile Data Fetched Successfully: $jsonResponse');
        final customer = CustomerModel.fromJson(jsonResponse);

        setState(() {
          profile = [customer];
          nameController.text = customer.name ?? '';
          mobileController.text = customer.mobile ?? '';
          emailController.text = customer.email ?? '';
          profilePhotoUrl = customer.photoUrl;
          aadhaarFrontUrl = customer.aadharFrontUrl;
          aadhaarBackUrl = customer.aadharBackUrl;
          isLoading = false;
        });
        print(customer.name);
        print(customer.mobile);
        print(customer.email);
      } else {
        setState(() {
          error = 'Failed to FETCH Profile: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  String? profilePhotoUrl;
  String? aadhaarFrontUrl;
  String? aadhaarBackUrl;

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
      showAppToast("Image Uploaded Successfully!");
    }
  }

  Future<void> updateprofile() async {
    // if (_photoFile == null || _aadhaarFront == null || _aadhaarBack == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Please upload photo, Aadhaar front and back")),
    //   );
    //   return;
    // }

    final dio = Dio();

    final userData = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": mobileController.text.trim(),
      // "password": passwordController.text.trim(),
      // "role": "ROLE_DELIVERY_BOY",
      // "storeId": selectedStore == 'Store 1' ? 1 : 2,
    };

    try {
      final formData = FormData();

      formData.fields.add(MapEntry('userData', json.encode(userData)));

      // Profile photo
      if (_photoFile != null) {
        formData.files.add(
          MapEntry(
            'photo',
            await MultipartFile.fromFile(
              _photoFile!.path,
              filename: _photoFile!.path.split('/').last,
            ),
          ),
        );
      } else if (profilePhotoUrl != null) {
        formData.fields.add(MapEntry('photoUrl', profilePhotoUrl!));
      }

      // Aadhaar front
      if (_aadhaarFront != null) {
        formData.files.add(
          MapEntry(
            'aadharFront',
            await MultipartFile.fromFile(
              _aadhaarFront!.path,
              filename: _aadhaarFront!.path.split('/').last,
            ),
          ),
        );
      } else if (aadhaarFrontUrl != null) {
        formData.fields.add(MapEntry('aadharFrontUrl', aadhaarFrontUrl!));
      }

      // Aadhaar back
      if (_aadhaarBack != null) {
        formData.files.add(
          MapEntry(
            'aadharBack',
            await MultipartFile.fromFile(
              _aadhaarBack!.path,
              filename: _aadhaarBack!.path.split('/').last,
            ),
          ),
        );
      } else if (aadhaarBackUrl != null) {
        formData.fields.add(MapEntry('aadharBackUrl', aadhaarBackUrl!));
      }

      final response = await dio.put(
        "${ApiConstant.baseUrl}/auth/update-profile",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization':
                'Bearer ${SharedPreferencesHelper.getTokendeliveryboy()}',
          },
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        showAppToast(
          response.data['message'] ?? "Profile Updated successfully",
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
  void initState() {
    super.initState();
    fetchProfile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appcolors.yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Appcolors.white),
            onPressed: () {
              // Handle notification icon press
              SharedPreferencesHelper.setIsLoggedIn(status: false);
              SharedPreferencesHelper.clearRole();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Appcolors.yellow,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSize(20),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                      vSize(15),
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      vSize(8),
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
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
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
                    Text("NAME"),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: nameController,
                      enabled: true,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        // hintText: "+91 88888 34213",
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
                        // suffixIcon: GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       _isEditing = !_isEditing;
                        //     });
                        //   },
                        //   child: Icon(Icons.edit, size: 16, color: Colors.grey),
                        // ),
                      ),
                    ),
                    vSize(20),
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

                    SizedBox(height: 20),
                    // Upload PHOTO
                    imageUploader(
                      "UPLOAD PHOTO",
                      _photoFile,
                      () => _uploadImage((f) => setState(() => _photoFile = f)),
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
                      () =>
                          _uploadImage((f) => setState(() => _aadhaarBack = f)),
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateprofile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.green,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "UPDATE",
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
            enabled: false,
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

  // Widget formField(
  //   String label,
  //   TextEditingController controller, {
  //   bool enabled = true,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label),
  //       vSize(5),
  //       TextFormField(
  //         controller: controller,
  //         enabled: enabled && _isEditing,
  //         decoration: InputDecoration(
  //           filled: true,
  //           fillColor: Colors.grey[200],
  //           hintText: label,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none,
  //           ),
  //           suffixIcon: Icon(Icons.edit, size: 16, color: Colors.grey),
  //         ),
  //       ),
  //       vSize(20),
  //     ],
  //   );
  // }

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
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "No file chosen",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            hSize(10),
            ElevatedButton(
              onPressed: onUpload,
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
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("SELECT", style: TextStyle(color: Colors.black54)),
              Icon(Icons.arrow_drop_down, color: Colors.black54),
            ],
          ),
        ),
      ],
    );
  }

  Widget expandedUploadBtn(VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Appcolors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text("UPLOAD", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
