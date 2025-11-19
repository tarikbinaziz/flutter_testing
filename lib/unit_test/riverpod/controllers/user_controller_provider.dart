import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_flow/unit_test/dio_api_service/services/user_service.dart';
import 'package:flutter_test_flow/unit_test/repository_layer/user_repository.dart';
import 'package:flutter_test_flow/unit_test/riverpod/controllers/user_controller.dart';
import 'package:flutter_test_flow/unit_test/riverpod/states/user_state.dart';

final userControllerProvider =
    StateNotifierProvider<UserController, UserState>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UserController(repo);
});

final userRepositoryProvider = Provider((ref) {
  return UserRepository(ref.read(userServiceProvider));
});
