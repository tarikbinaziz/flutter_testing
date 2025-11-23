import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_testing_all/features/auth/controllers/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(key: const Key('login_email')),
            const SizedBox(height: 10),
            TextField(key: const Key('login_password')),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('login_button'),
              onPressed: () async {
                await ref.read(authControllerProvider.notifier)
                    .login('demo@mail.com', '123456');
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
