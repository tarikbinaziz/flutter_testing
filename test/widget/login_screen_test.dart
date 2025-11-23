// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_testing_all/models/user_model.dart';
// import 'package:flutter_testing_all/unit_test/repository_layer/user_repository.dart';
// import 'package:flutter_testing_all/unit_test/riverpod/controllers/user_controller_provider.dart';
// import 'package:mocktail/mocktail.dart';


// // Mock repository used by controller (so controller works)
// class MockUserRepository extends Mock implements UserRepository {}

// void main() {
//   late MockUserRepository mockRepo;

//   setUp(() {
//     mockRepo = MockUserRepository();
//   });

//   testWidgets('Login success navigates to Home', (tester) async {
//     // Arrange
//     final mockUser = UserModel(id:1, name:'tarik', email:'e@e.com', token: 'abc');
//     when(() => mockRepo.login('e@e.com','pass')).thenAnswer((_) async => mockUser);

//     // Provide overridden providers used in your app
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           userRepositoryProvider.overrideWithValue(mockRepo),
//           // override tokenStorage if login saves token
//         ],
//         child: MaterialApp(
//           home: LoginScreen(),
//           routes: {
//             '/home': (c) => Scaffold(body: Text('HOME SCREEN')),
//           },
//         ),
//       ),
//     );

//     // Find fields and button
//     final emailFinder = find.byKey(const Key('login_email'));
//     final passFinder = find.byKey(const Key('login_password'));
//     final buttonFinder = find.byKey(const Key('login_button'));

//     await tester.enterText(emailFinder, 'e@e.com');
//     await tester.enterText(passFinder, 'pass');

//     // Act
//     await tester.tap(buttonFinder);
//     await tester.pump(); // start loading
//     expect(find.byType(CircularProgressIndicator), findsOneWidget); // loading

//     // allow async
//     await tester.pumpAndSettle();

//     // Assert navigation to home
//     expect(find.text('HOME SCREEN'), findsOneWidget);
//   });

//   testWidgets('Login error shows error message', (tester) async {
//     when(() => mockRepo.login(any(), any())).thenThrow(Exception('Invalid'));

//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           userRepositoryProvider.overrideWithValue(mockRepo),
//         ],
//         child: MaterialApp(home: LoginScreen()),
//       ),
//     );

//     await tester.enterText(find.byKey(const Key('login_email')), 'e@e.com');
//     await tester.enterText(find.byKey(const Key('login_password')), 'wrong');

//     await tester.tap(find.byKey(const Key('login_button')));
//     await tester.pump(); // show loading
//     await tester.pumpAndSettle();

//     expect(find.textContaining('Invalid'), findsOneWidget);
//   });
// }
