// lib/full_test/controllers/auth_controller_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_testing_all/features/auth/controllers/auth_state.dart';
import 'package:flutter_testing_all/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_testing_all/features/auth/data/repositories/auth_repository_fake.dart';
import 'package:flutter_testing_all/features/auth/data/repositories/auth_repository_real.dart';
import 'package:flutter_testing_all/full_test/dio_api_service/repositories/auth_repository.dart';

import 'auth_controller.dart';
import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:dio/dio.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (kDebugMode) {
    return AuthRepositoryFake(); // development/test
  } else {
    final dio = Dio(BaseOptions(baseUrl: "https://api.yourapp.com"));
    return AuthRepositoryReal(dio); // production
  }
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});





class AuthController extends StateNotifier<AuthState> {
  final AuthRepository repo;

  AuthController(this.repo) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await repo.login(email, password);
      await repo.saveToken("token_from_login");
      state = state.copyWith(loading: false, user: user);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> checkAuth() async {
    final token = await repo.getToken();
    return token != null;
  }

  Future<void> logout() async {
    await repo.clearToken();
    state = const AuthState();
  }
}
