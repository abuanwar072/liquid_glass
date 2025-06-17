import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/sample_1.png',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/sample_2.jpg',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/sample_3.jpg',
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
