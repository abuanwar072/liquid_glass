import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey backgroundKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: backgroundKey,
        child: SingleChildScrollView(
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
      ),
    );
  }
}
