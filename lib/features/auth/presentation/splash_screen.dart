import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const keySplash = Key("splash_screen");

  const SplashScreen({super.key = keySplash});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final isLoggedIn = await ref
        .read(authControllerProvider.notifier)
        .checkAuth();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      key: Key("splash_logo"),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
