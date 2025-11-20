import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  static const keyEmail = Key("login_email");
  static const keyPassword = Key("login_password");
  static const keyLoginBtn = Key("login_button");

  LoginScreen({super.key});

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (prev, next) {
      if (next.user != null) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              key: keyEmail,
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              key: keyPassword,
              controller: passCtrl,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: keyLoginBtn,
              onPressed: state.loading
                  ? null
                  : () {
                      ref
                          .read(authControllerProvider.notifier)
                          .login(emailCtrl.text, passCtrl.text);
                    },
              child: state.loading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
