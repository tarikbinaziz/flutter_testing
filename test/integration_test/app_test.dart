// import 'package:flutter_test_flow/full_test/core/storage/token_storage.dart';
// import 'package:flutter_test_flow/full_test/providers/dio_provider.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dio/dio.dart';
// import 'package:http_mock_adapter/http_mock_adapter.dart';



// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('Splash -> Login -> Home full flow', (tester) async {
//     // 1) Prepare mocked Dio and adapter
//     final dio = Dio(BaseOptions());
//     final adapter = DioAdapter(dio: dio);
//     dio.httpClientAdapter = adapter;

//     // Mock login response
//     adapter.onPost(
//       '/login',
//       data: {'email': 'e@e.com', 'password': 'pass'},
//       (server) => server.reply(200, {
//         'id': 1,
//         'name': 'tarik',
//         'email': 'e@e.com',
//         'token': 'abc123',
//       }),
//     );

//     // Mock profile or initial call if Splash fetches token/profile
//     adapter.onGet(
//       '/profile',
//       (server) => server.reply(200, {
//         'id': 1,
//         'name': 'tarik',
//         'email': 'e@e.com',
//       }),
//     );

//     // 2) Provide a fake in-memory token storage
//     final fakeStorage = _InMemoryTokenStorage();

//     // 3) Start app with ProviderScope overrides
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           dioProvider.overrideWithValue(dio),
//           tokenStorageProvider.overrideWithValue(fakeStorage),
//         ],
//         child: const app.MyApp(), // your app entry widget
//       ),
//     );

//     // Allow splash to render; if your splash does async, pump accordingly
//     await tester.pumpAndSettle();

//     // At this point user should be on Login if no token saved
//     expect(find.byKey(const Key('login_email')), findsOneWidget);

//     // Fill login form
//     await tester.enterText(find.byKey(const Key('login_email')), 'e@e.com');
//     await tester.enterText(find.byKey(const Key('login_password')), 'pass');

//     // Tap login
//     await tester.tap(find.byKey(const Key('login_button')));
//     await tester.pump(); // show loading
//     await tester.pumpAndSettle(); // wait navigation / async

//     // After login, token should be stored
//     expect(await fakeStorage.getToken(), 'abc123');

//     // Home screen assertion
//     expect(find.textContaining('Welcome'), findsOneWidget); // adjust to your Home UI
//   });
// }

// // Simple in-memory storage for tests
// class _InMemoryTokenStorage implements TokenStorage {
//   String? _token;
//   @override
//   Future<void> clear() async { _token = null; }

//   @override
//   Future<String?> getToken() async => _token;

//   @override
//   Future<void> saveToken(String token) async { _token = token; }
// }
