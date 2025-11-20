import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_flow/full_test/dio_api_service/repositories/auth_repository.dart';
import 'package:flutter_test_flow/full_test/domain/usecases/login_usecase.dart';
import '../data/token_storage.dart';
import '../domain/login_usecase.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository repo;
  final TokenStorage tokenStorage;
  final LoginUseCase loginUseCase;

  AuthController(this.repo, this.tokenStorage, this.loginUseCase)
      : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await loginUseCase(email, password);

      // fake token
      await tokenStorage.saveToken("dummy_token");

      state = state.copyWith(loading: false, user: user);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> checkAuth() async {
    final token = await tokenStorage.getToken();
    return token != null;
  }

  Future<void> logout() async {
    await tokenStorage.clearToken();
    state = const AuthState();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final tokenStore = ref.watch(tokenStorageProvider);
  final loginUseCase = LoginUseCase(repo);

  return AuthController(repo, tokenStore, loginUseCase);
});
