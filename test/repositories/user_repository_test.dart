import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_flow/unit_test/repository_layer/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test_flow/models/user_model.dart';
import 'package:flutter_test_flow/unit_test/dio_api_service/services/user_service.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  late MockUserService mockService;
  late UserRepository repository;

  setUp(() {
    mockService = MockUserService();
    repository = UserRepository(mockService);
  });

  test('getUser returns UserModel on success', () async {
    final mockUser = UserModel(
      id: 1,
      name: "tarik",
      email: "e@e.com",
      balance: 100.0,
    );

    when(() => mockService.fetchUser())
        .thenAnswer((_) async => mockUser);

    final result = await repository.getUser();

    expect(result, isA<UserModel>());
    expect(result.name, "tarik");
  });

  test('getUser throws custom exception on error', () async {
    when(() => mockService.fetchUser())
        .thenThrow(Exception("Network error"));

    expect(
      () => repository.getUser(),
      throwsA(isA<Exception>()),
    );
  });

  // POST Test
  test('createUser returns UserModel', () async {
    final mockBody = {"name": "tarik"};
    final mockUser = UserModel(
      id: 1,
      name: "tarik",
      email: "x@x.com",
      balance: 0.0,
    );

    when(() => mockService.createUser(mockBody))
        .thenAnswer((_) async => mockUser);

    final result = await repository.createUser(mockBody);

    expect(result.id, 1);
    expect(result.name, "tarik");
  });

  // PUT Test
  test('updateUser returns updated model', () async {
    final updatedBody = {"name": "Updated"};
    final mockUser = UserModel(
      id: 1,
      name: "Updated",
      email: "e@e.com",
      balance: 100.0,
    );

    when(() => mockService.updateUser(1, updatedBody))
        .thenAnswer((_) async => mockUser);

    final result = await repository.updateUser(1, updatedBody);

    expect(result.name, "Updated");
  });

  // DELETE Test
  test('deleteUser returns true', () async {
    when(() => mockService.deleteUser(1))
        .thenAnswer((_) async => true);

    final result = await repository.deleteUser(1);

    expect(result, true);
  });
}
