import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_all/features/auth/controllers/auth_controller.dart';
import 'package:flutter_testing_all/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_testing_all/features/auth/presentation/splash_screen.dart';
import 'package:flutter_testing_all/main.dart' as app;
import 'package:flutter_testing_all/models/user_model.dart';
import 'package:integration_test/integration_test.dart';

// A test-only auth repository that simulates a logged-out device (null token)
// but still supports login so the test can proceed from Login -> Home.
class _LoggedOutAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserModel(id: 1, name: 'Test User', email: email, balance: 0);
  }

  @override
  Future<String?> getToken() async {
    // Simulate not logged in
    return null;
  }

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> clearToken() async {}
}

/*
  Integration test: Full app flow from Splash -> Login -> Home

  Purpose:
  - Verify the app shows the splash screen on startup,
    then navigates to the login screen, accepts credentials,
    and finally lands on the home screen.

  Steps performed by this test (high-level):
  1) Launch the app widget tree (wrapped in `ProviderScope`).
  2) Confirm the `SplashScreen` is present.
  3) Wait for the splash delay/navigation and settle animations.
  4) Confirm the login form is visible (email, password, button).
  5) Enter credentials and tap the login button.
  6) Wait for navigation and assert the home screen shows expected text.

  How to run (example):
  - On a connected device / emulator:
    flutter test integration_test --device-id <device-id>

  Notes / next steps:
  - If your app uses platform channels or native services during
    startup, prefer calling `app.main()` instead of pumping the widget.
  - Add more assertions (API calls, persisted state) as needed.
*/

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash → Login → Home', (tester) async {
    // 0) Launch the app widget tree in a testable way. We wrap the
    //    real app widget with `ProviderScope` so Riverpod providers
    //    resolve just like in production. Using `app.main()` is also
    //    valid for full integration runs.
    // Override the auth repository to simulate a logged-out state so the
    // splash screen navigates to the login screen in tests.
    final loggedOutRepo = _LoggedOutAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(loggedOutRepo)],
        child: const app.MyApp(),
      ),
    );

    // 1) Allow the first frame to build and display the splash screen.
    //    A tiny pump ensures widgets appear before we assert.
    await tester.pump(const Duration(milliseconds: 100));

    // 1️⃣ SPLASH SCREEN: Confirm splash is visible
    // Use the concrete `SplashScreen` type (imported above) so the
    // analyzer can resolve the widget reference.
    expect(
      find.byType(SplashScreen),
      findsOneWidget,
      reason: 'SplashScreen should appear immediately on startup',
    );

    // 2) Wait for the splash's internal delay/navigation logic to run.
    //    Use a duration slightly longer than the implementation's delay
    //    and then allow animations to settle with `pumpAndSettle()`.
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    // 2️⃣ LOGIN SCREEN: Verify login fields and button exist
    final emailFinder = find.byKey(const Key('login_email'));
    final passwordFinder = find.byKey(const Key('login_password'));
    final loginButtonFinder = find.byKey(const Key('login_button'));

    expect(
      emailFinder,
      findsOneWidget,
      reason: 'Email input should be present on Login screen',
    );
    expect(
      passwordFinder,
      findsOneWidget,
      reason: 'Password input should be present on Login screen',
    );
    expect(
      loginButtonFinder,
      findsOneWidget,
      reason: 'Login button should be present on Login screen',
    );

    // 3) Enter credentials into the login form.
    //    Use realistic test values; change as needed for your auth flow.
    await tester.enterText(emailFinder, 'demo@mail.com');
    await tester.enterText(passwordFinder, '123456');

    // 4) Tap the login button and wait for navigation to complete.
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();

    // 3️⃣ HOME SCREEN: Validate we arrived at the home screen
    expect(
      find.byKey(const Key('home_screen')),
      findsOneWidget,
      reason: 'App should navigate to Home after successful login',
    );
    expect(
      find.text('Welcome Home!'),
      findsOneWidget,
      reason: 'Home screen should display welcome text',
    );
  });
}
