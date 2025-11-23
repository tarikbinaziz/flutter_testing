import 'package:dio/dio.dart';
import 'package:flutter_testing_all/unit_test/dio_api_service/services/user_service.dart';

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
