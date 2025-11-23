// lib/full_test/dio_api_service/repositories/auth_repository_real.dart
import 'package:flutter_testing_all/models/user_model.dart';

import 'auth_repository.dart';

import 'package:dio/dio.dart';

class AuthRepositoryReal implements AuthRepository {
  final Dio dio;

  AuthRepositoryReal(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    return UserModel.fromJson(response.data);
  }

  @override
  Future<String?> getToken() async {
    // SharedPreferences or SecureStorage
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    // save token in storage
  }

  @override
  Future<void> clearToken() async {
    // clear storage
  }
}
