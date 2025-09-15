import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Nama Aplikasi: Flutter"),
            Text("Versi: 3.35.2"),
            Text("Developer: Ditha Alfariz"),
          ],
        ),
      ),
    );
  }
}
