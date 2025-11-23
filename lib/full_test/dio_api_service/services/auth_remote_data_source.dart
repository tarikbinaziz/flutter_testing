import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_flow/full_test/providers/dio_provider.dart';
import 'package:flutter_test_flow/models/user_model.dart';

/// Remote data source handles direct API calls
class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        message: e.response?.data?['message'] ?? 'Login failed',
        response: e.response,
        type: e.type,
      );
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get('/profile');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        message: e.response?.data?['message'] ?? 'Profile fetch failed',
        response: e.response,
        type: e.type,
      );
    }
  }

  Future<void> logout() async {
    try {
      await dio.post('/logout');
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        message: e.response?.data?['message'] ?? 'Logout failed',
        response: e.response,
        type: e.type,
      );
    }
  }
}

/// Provide remote datasource with dio provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSource(dio);
});
