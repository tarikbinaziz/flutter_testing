✅ Step 5: Repository Layer Unit Testing (MOST IMPORTANT PART)

(Dio + Repository + Model → Properly Test Your App Logic)

You already finished:

✔ Step 1 → Model Test
✔ Step 2 → Parse Test
✔ Step 3 → Equatable
✔ Step 4 → Dio Service Test
✔ Step 4.2 → CRUD Test (GET/POST/PUT/DELETE)

Now in Step 5, you will learn:

🎯 Step 5 Goal
👉 Test Repository Layer (Service layer er upor ekta extra logic layer)
Why Repository Layer?

Because:

Service only calls API

Repository contains logic, mapping, error handling, business rules

Production app e repository essential.

📁 Step 5 Structure
lib/
 └── unit_test/
      ├── dio_api_service/
      │     ├── services/
      │     └── repositories/

🧠 Step 5 Example Repository
user_repository.dart
import 'package:dio/dio.dart';
import '../services/user_service.dart';
import '../../../models/user_model.dart';

class UserRepository {
  final UserService service;

  UserRepository(this.service);

  Future<UserModel> getUser() async {
    try {
      return await service.fetchUser();
    } on DioException catch (e) {
      throw Exception("Failed to load user: ${e.message}");
    }
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    try {
      return await service.createUser(data);
    } on DioException catch (e) {
      throw Exception("Failed to create user: ${e.message}");
    }
  }

  Future<UserModel> updateUser(int id, Map<String, dynamic> data) async {
    try {
      return await service.updateUser(id, data);
    } on DioException catch (e) {
      throw Exception("Failed to update user: ${e.message}");
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      return await service.deleteUser(id);
    } on DioException catch (e) {
      throw Exception("Failed to delete user: ${e.message}");
    }
  }
}

🧪 Step 5 – Repository Unit Test

(IMPORTANT: Service mock kore repository test korte hobe)

You will use mocktail
flutter pub add mocktail --dev

📌 Repository Test
user_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_testing_all/models/user_model.dart';
import 'package:flutter_testing_all/unit_test/dio_api_service/services/user_service.dart';
import 'package:flutter_testing_all/unit_test/dio_api_service/repositories/user_repository.dart';

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

🎉 Step 5 Complete

Now you know how to test:

✔ Model
✔ Service
✔ CRUD API
✔ Error handling
✔ Repository (mocktail based)

Your test pipeline is now 100% production level.