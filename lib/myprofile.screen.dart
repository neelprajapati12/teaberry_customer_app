import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: ProfileScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      filled: true,
      fillColor: const Color(0xFFF1F6FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      suffixIcon: const Icon(Icons.edit, size: 16, color: Colors.grey),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF4D471),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile_image.png'),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'You may edit your details here.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              buildLabel("NAME"),
              TextFormField(
                initialValue: "Adam Doe",
                decoration: inputDecoration,
              ),
              const SizedBox(height: 10),
              buildLabel("MOBILE NO"),
              TextFormField(
                initialValue: "+91 88888 34213",
                decoration: inputDecoration,
              ),
              const SizedBox(height: 10),
              buildLabel("EMAIL"),
              TextFormField(
                initialValue: "adam.doe@gmail.com",
                decoration: inputDecoration,
              ),
              const SizedBox(height: 10),
              buildLabel("NEAREST STORE"),
              DropdownButtonFormField<String>(
                decoration: inputDecoration.copyWith(
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                ),
                items: const [
                  DropdownMenuItem(value: "store1", child: Text("Store 1")),
                  DropdownMenuItem(value: "store2", child: Text("Store 2")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              buildLabel("ADDRESS"),
              TextFormField(
                initialValue: "27-A, Aparna apartments, Gurudev..",
                decoration: inputDecoration,
              ),
              const SizedBox(height: 10),
              buildLabel("PASSWORD"),
              TextFormField(
                obscureText: true,
                initialValue: "***********",
                decoration: inputDecoration.copyWith(
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 10),
              buildLabel("RE-TYPE PASSWORD"),
              TextFormField(
                obscureText: true,
                initialValue: "***********",
                decoration: inputDecoration.copyWith(
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7AAC4B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "UPDATE",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 4),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}