// lib/full_test/dio_api_service/repositories/auth_repository_fake.dart
import 'package:flutter_testing_all/models/user_model.dart';

import 'auth_repository.dart';

class AuthRepositoryFake implements AuthRepository {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
    return UserModel(id: 1, name: 'Test User', email: email, balance: 100);
  }

  @override
  Future<String?> getToken() async {
    return "dummy_token";
  }

  @override
  Future<void> saveToken(String token) async {
    // do nothing
  }

  @override
  Future<void> clearToken() async {}
}
