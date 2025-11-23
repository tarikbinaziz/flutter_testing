import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_testing_all/models/user_model.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  return UserService(dio);
});

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<UserModel> fetchUser() async {
    final response = await dio.get('/user');
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    final response = await dio.post('/user', data: data);
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateUser(int id, Map<String, dynamic> data) async {
    final response = await dio.put('/user/$id', data: data);
    return UserModel.fromJson(response.data);
  }

  Future<bool> deleteUser(int id) async {
    final response = await dio.delete('/user/$id');
    return response.statusCode == 200;
  }
}
