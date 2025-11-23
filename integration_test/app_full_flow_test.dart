// integration_test/app_full_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_all/main.dart' as app;
import 'package:integration_test/integration_test.dart';

import 'fake_provider_override.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash → Login → Home (Fake Auth)', (tester) async {
    // override providers with fake
    await tester.pumpWidget(
      ProviderScope(parent: testContainer, child: const app.MyApp()),
    );

    await tester.pumpAndSettle();

    // -----------------------------
    // 1️⃣ SPLASH SCREEN LOADED
    // -----------------------------
    expect(find.byKey(const Key('splash_logo')), findsOneWidget);

    // Wait for splash to finish navigation
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // -----------------------------
    // 2️⃣ LOGIN SCREEN
    // -----------------------------
    expect(find.byKey(const Key('login_email')), findsOneWidget);
    expect(find.byKey(const Key('login_password')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);

    // Enter email & password
    await tester.enterText(
      find.byKey(const Key('login_email')),
      'demo@mail.com',
    );
    await tester.enterText(find.byKey(const Key('login_password')), '123456');
    await tester.pump();

    // Tap login
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // -----------------------------
    // 3️⃣ HOME SCREEN
    // -----------------------------
    expect(find.byKey(const Key('home_screen')), findsOneWidget);
    expect(find.text('Welcome Home!'), findsOneWidget);
  });
}
