import 'package:flutter/material.dart';
import 'package:teaberryapp_project/productscreen1.dart';
import 'package:teaberryapp_project/resturantview_screen.dart';

// void main() {
//   runApp(TeaBerryApp());
// }
//
// class TeaBerryApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tea Berry - Verification',
//       home: VerificationScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<TextEditingController> controllers = List.generate(4, (index) => TextEditingController());
  int resendSeconds = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Color(0xFFF2D269), // Yellow header
              padding: EdgeInsets.only(top: 50, left: 20),
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0, -40, 0),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Verification',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                        children: [
                          TextSpan(text: 'We have sent a code to your email\n'),
                          TextSpan(
                            text: 'example@gmail.com',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CODE',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Resend in ${resendSeconds}s',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F4F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controllers[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.length == 1 && index < 3) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                            ),
                    );
                      // Add your verification logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF749D3E), // Green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'VERIFY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}