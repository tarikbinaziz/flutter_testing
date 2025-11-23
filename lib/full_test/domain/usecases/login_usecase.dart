import 'package:flutter_test_flow/full_test/dio_api_service/repositories/auth_repository.dart';
import 'package:flutter_test_flow/models/user_model.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserModel> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email or password can't be empty");
    }

    return await repository.login(email, password);
  }
}
