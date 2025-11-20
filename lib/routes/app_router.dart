import 'package:flutter/material.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/home_screen.dart';

class AppRouter {
  static final routes = {
    "/": (context) => const SplashScreen(),
    "/login": (context) => LoginScreen(),
    "/home": (context) => const HomeScreen(),
  };
}
