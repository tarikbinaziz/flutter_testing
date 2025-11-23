et’s build a complete test plan and code so you can test Splash → Login → Home using unit, widget, and integration tests. I’ll give you ready-to-copy files, explanations (English + Bangla), and exact commands to run. No gaps — follow the steps and paste the code into your project.

Overview (what you'll get)

Unit tests

Login UseCase / Repository behavior (mocked service)

Widget tests

Login screen UI: tap login, loading indicator, error, navigation trigger

Integration test

Full flow: Splash → Login (mocked network) → Home (assert visible)

Key packages used (add to pubspec.yaml if you don't have them):

dev_dependencies:
  flutter_test:
  integration_test:
  mocktail: ^0.3.0
  http_mock_adapter: ^0.6.0


Run:

flutter pub get


Note: you probably already have some of these from earlier steps.

Assumptions & small helpers (so tests are easy to override)

Use small abstractions so tests can override easily:

dio_provider.dart — provides Dio instance (so tests can override with a mocked Dio).

token_storage.dart — wrapper around FlutterSecureStorage (so tests can override or fake token storage).

App entry main.dart uses ProviderScope so tests can override providers.

If you already have these, use them; otherwise add simple versions below.

lib/providers/dio_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'https://api.example.com'));
});

lib/core/storage/token_storage.dart
abstract class TokenStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  // use flutter_secure_storage in production
  @override
  Future<void> saveToken(String token) async {/* real impl */}
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> clear() async {/* real impl */}
}


Provide a provider:

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage();
});


With this you can override both dioProvider and tokenStorageProvider in tests.

1) Unit Tests — Login UseCase & Repository
Files to test:

lib/unit_test/dio_api_service/services/auth_remote_data_source.dart (or your existing service)

lib/unit_test/dio_api_service/repositories/auth_repository.dart

lib/domain/usecases/login_usecase.dart

Below is a unit test for LoginUseCase using mocktail.

test/unit/login_usecase_test.dart (copy/paste)
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:your_app_name/unit_test/dio_api_service/services/auth_service.dart';
import 'package:your_app_name/unit_test/dio_api_service/repositories/auth_repository.dart';
import 'package:your_app_name/domain/usecases/login_usecase.dart';
import 'package:your_app_name/models/user_model.dart';

class MockAuthService extends Mock implements AuthService {}
class FakeUserModel extends Fake implements UserModel {}

void main() {
  late MockAuthService mockService;
  late AuthRepository repository;
  late LoginUseCase usecase;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockService = MockAuthService();
    repository = AuthRepository(mockService); // adapt to your constructor
    usecase = LoginUseCase(repository);
  });

  test('login returns UserModel on success', () async {
    final mockUser = UserModel(id: 1, name: 'tarik', email: 'e@e.com', token: 'abc');

    when(() => mockService.login('e@e.com', 'pass'))
      .thenAnswer((_) async => mockUser);

    final result = await usecase.call('e@e.com', 'pass');

    expect(result, isA<UserModel>());
    expect(result.token, 'abc');
  });

  test('login throws when service fails', () async {
    when(() => mockService.login(any(), any()))
      .thenThrow(Exception('Network error'));

    expect(
      () => usecase.call('e@e.com', 'pass'),
      throwsA(isA<Exception>()),
    );
  });
}


English: This unit test checks success and failure for the login use case while mocking the low-level service.
Bangla: Eta login usecase er unit test — success & failure case mock kore test kora holo.

Run unit tests:

flutter test test/unit/login_usecase_test.dart


#####

2) Widget Tests — Login Screen

We will test:

Input fields exist

Tapping Login calls controller and shows loading

On success, app navigates to Home screen (we'll assert Home text exists)

On error, error text shows

Important: override providers (dio, token storage, repository) with mocked versions.

Example widget test code:

test/widget/login_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:your_app_name/presentation/screens/login_screen.dart';
import 'package:your_app_name/unit_test/riverpod/repositories/user_repository.dart';
import 'package:your_app_name/models/user_model.dart';

// Mock repository used by controller (so controller works)
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
  });

  testWidgets('Login success navigates to Home', (tester) async {
    // Arrange
    final mockUser = UserModel(id:1, name:'tarik', email:'e@e.com', token: 'abc');
    when(() => mockRepo.login('e@e.com','pass')).thenAnswer((_) async => mockUser);

    // Provide overridden providers used in your app
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockRepo),
          // override tokenStorage if login saves token
        ],
        child: MaterialApp(
          home: LoginScreen(),
          routes: {
            '/home': (c) => Scaffold(body: Text('HOME SCREEN')),
          },
        ),
      ),
    );

    // Find fields and button
    final emailFinder = find.byKey(const Key('login_email'));
    final passFinder = find.byKey(const Key('login_password'));
    final buttonFinder = find.byKey(const Key('login_button'));

    await tester.enterText(emailFinder, 'e@e.com');
    await tester.enterText(passFinder, 'pass');

    // Act
    await tester.tap(buttonFinder);
    await tester.pump(); // start loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // loading

    // allow async
    await tester.pumpAndSettle();

    // Assert navigation to home
    expect(find.text('HOME SCREEN'), findsOneWidget);
  });

  testWidgets('Login error shows error message', (tester) async {
    when(() => mockRepo.login(any(), any())).thenThrow(Exception('Invalid'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.enterText(find.byKey(const Key('login_email')), 'e@e.com');
    await tester.enterText(find.byKey(const Key('login_password')), 'wrong');

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(); // show loading
    await tester.pumpAndSettle();

    expect(find.textContaining('Invalid'), findsOneWidget);
  });
}

Notes:

Add Keys in your LoginScreen widgets for stability:

email Key('login_email')

password Key('login_password')

login button Key('login_button')

Replace userRepositoryProvider with the provider used by your app.

The LoginScreen should navigate with Navigator.pushNamed(context, '/home') on success.

Run widget tests:

flutter test test/widget/login_screen_test.dart


Bangla: Widget test e UI interaction simulate kore login er success/error diye assertion kora hoy.

3) Integration Test — Full flow (Splash → Login → Home)

Integration tests run the app. We'll run the real app but override network and storage providers to use mocked Dio (http_mock_adapter) and an in-memory token storage.

Key idea:

In integration_test/app_test.dart create Dio + DioAdapter, override dioProvider and tokenStorageProvider when pumping your app in the test.

Use IntegrationTestWidgetsFlutterBinding.ensureInitialized().

Example integration test (copy/paste):

integration_test/app_test.dart

import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:your_app_name/main.dart' as app;
import 'package:your_app_name/providers/dio_provider.dart';
import 'package:your_app_name/core/storage/token_storage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash -> Login -> Home full flow', (tester) async {
    // 1) Prepare mocked Dio and adapter
    final dio = Dio(BaseOptions());
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    // Mock login response
    adapter.onPost(
      '/login',
      data: {'email': 'e@e.com', 'password': 'pass'},
      (server) => server.reply(200, {
        'id': 1,
        'name': 'tarik',
        'email': 'e@e.com',
        'token': 'abc123',
      }),
    );

    // Mock profile or initial call if Splash fetches token/profile
    adapter.onGet(
      '/profile',
      (server) => server.reply(200, {
        'id': 1,
        'name': 'tarik',
        'email': 'e@e.com',
      }),
    );

    // 2) Provide a fake in-memory token storage
    final fakeStorage = _InMemoryTokenStorage();

    // 3) Start app with ProviderScope overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dioProvider.overrideWithValue(dio),
          tokenStorageProvider.overrideWithValue(fakeStorage),
        ],
        child: const app.MyApp(), // your app entry widget
      ),
    );

    // Allow splash to render; if your splash does async, pump accordingly
    await tester.pumpAndSettle();

    // At this point user should be on Login if no token saved
    expect(find.byKey(const Key('login_email')), findsOneWidget);

    // Fill login form
    await tester.enterText(find.byKey(const Key('login_email')), 'e@e.com');
    await tester.enterText(find.byKey(const Key('login_password')), 'pass');

    // Tap login
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(); // show loading
    await tester.pumpAndSettle(); // wait navigation / async

    // After login, token should be stored
    expect(await fakeStorage.getToken(), 'abc123');

    // Home screen assertion
    expect(find.textContaining('Welcome'), findsOneWidget); // adjust to your Home UI
  });
}

// Simple in-memory storage for tests
class _InMemoryTokenStorage implements TokenStorage {
  String? _token;
  @override
  Future<void> clear() async { _token = null; }

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> saveToken(String token) async { _token = token; }
}

How to run integration test:
flutter test integration_test/app_test.dart


Or (recommended on device/emulator):

flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart


Newer Flutter supports flutter test integration_test which runs on device/emulator. If you encounter binding issues, use flutter drive approach — see Flutter docs for your SDK version.

Bangla: Integration test e puro app run kore real navigation, token storage etc. simulate kora hoy — kintu network mock kora to keep tests offline.

Extra Tips & Gotchas

Provider overrides are the key: override dioProvider and tokenStorageProvider so your tests control the networking and storage.

Use http_mock_adapter for Dio mocking (both unit/widget/integration tests).

Add Keys to important UI elements (email/password/button) — makes tests stable.

For widget tests use pumpWidget(ProviderScope(...)); for integration tests pump full app entry.

For asynchronous process in widget tests:

Use await tester.pump() to start animations/loading.

Use await tester.pumpAndSettle() to wait until no transient frames remain.

If your app uses deep initializations in main(), consider providing MyApp() separate from main() so tests can instantiate MyApp() without running main() top-level effects.

If you use SharedPreferences / FlutterSecureStorage, create an abstract TokenStorage and provider to be able to override in tests (we did that above).

Use mocktail to mock repository/service in unit & widget tests.

Checklist (quick)

 Add Keys to Login screen widgets

 Provide dioProvider & tokenStorageProvider

 Add http_mock_adapter & mocktail to dev_dependencies

 Create unit tests (usecases/repositories)

 Create widget tests (login screen)

 Create integration tests (full flow)

 Run flutter test and flutter test integration_test/app_test.dart

Commands summary

Run all unit & widget tests:

flutter test


Run a single test:

flutter test test/widget/login_screen_test.dart


Run integration tests:

flutter test integration_test/app_test.dart


or use flutter drive if your setup requires it.