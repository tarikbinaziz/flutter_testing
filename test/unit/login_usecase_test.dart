// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_test_flow/full_test/dio_api_service/repositories/auth_repository.dart';
// import 'package:flutter_test_flow/full_test/domain/usecases/login_usecase.dart';
// import 'package:flutter_test_flow/models/user_model.dart';
// import 'package:mocktail/mocktail.dart';



// class MockAuthService extends Mock implements AuthService {}
// class FakeUserModel extends Fake implements UserModel {}

// void main() {
//   late MockAuthService mockService;
//   late AuthRepository repository;
//   late LoginUseCase usecase;

//   setUpAll(() {
//     registerFallbackValue(FakeUserModel());
//   });

//   setUp(() {
//     mockService = MockAuthService();
//     repository = AuthRepository(mockService); // adapt to your constructor
//     usecase = LoginUseCase(repository);
//   });

//   test('login returns UserModel on success', () async {
//     final mockUser = UserModel(id: 1, name: 'tarik', email: 'e@e.com', token: 'abc');

//     when(() => mockService.login('e@e.com', 'pass'))
//       .thenAnswer((_) async => mockUser);

//     final result = await usecase.call('e@e.com', 'pass');

//     expect(result, isA<UserModel>());
//     expect(result.token, 'abc');
//   });

//   test('login throws when service fails', () async {
//     when(() => mockService.login(any(), any()))
//       .thenThrow(Exception('Network error'));

//     expect(
//       () => usecase.call('e@e.com', 'pass'),
//       throwsA(isA<Exception>()),
//     );
//   });
// }
