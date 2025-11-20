import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test_flow/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full App Flow Test: Splash → Login → Home', () {
    testWidgets('User goes from splash to login and logs in successfully to reach home screen',
        (WidgetTester tester) async {
      // Start the app
     app.main();
      await tester.pumpAndSettle();

      // -----------------------------
      // 1️⃣ SPLASH SCREEN LOADED
      // -----------------------------
      expect(find.byKey(const Key('splash_logo')), findsOneWidget);

      // Wait for splash to finish navigation
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // -----------------------------
      // 2️⃣ NAVIGATED TO LOGIN SCREEN
      // -----------------------------
      expect(find.byKey(const Key('login_email_field')), findsOneWidget);
      expect(find.byKey(const Key('login_password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);

      // Enter email
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'demo@mail.com',
      );

      // Enter password
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123456',
      );

      await tester.pump();

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(const Duration(seconds: 1));

      // Simulate waiting for network request
      await tester.pumpAndSettle();

      // -----------------------------
      // 3️⃣ SUCCESS → GO TO HOME
      // -----------------------------
      expect(find.byKey(const Key('home_screen')), findsOneWidget);

      // Home widgets
      expect(find.text('Welcome Home!'), findsOneWidget);
    });
  });
}
