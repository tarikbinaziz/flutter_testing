

import 'package:flutter_testing_all/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}
