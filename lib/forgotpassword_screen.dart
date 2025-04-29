import 'package:flutter/material.dart';
import 'package:teaberryapp_project/verification_screen.dart';

// void main() {
//   runApp(TeaBerryApp());
// }
//
// class TeaBerryApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tea Berry - Forgot Password',
//       home: ForgotPasswordScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Color(0xFFF2D269), // Yellow background
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
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Please sign in to your existing account',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'EMAIL',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F4F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'example@gmail.com',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationScreen(),
                            ),
                    );
                      // Add your send code logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF749D3E), // Green button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'SEND CODE',
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