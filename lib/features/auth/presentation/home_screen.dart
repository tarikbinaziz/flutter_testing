import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const keyHome = Key("home_screen");

  const HomeScreen({super.key = keyHome});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Welcome Home!")),
    );
  }
}
