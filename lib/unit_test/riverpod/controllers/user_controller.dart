import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_flow/unit_test/repository_layer/user_repository.dart';
import '../../../models/user_model.dart';
import '../states/user_state.dart';


class UserController extends StateNotifier<UserState> {
  final UserRepository repo;

  UserController(this.repo) : super(const UserState());

  Future<void> fetchUser() async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await repo.getUser();
      state = state.copyWith(loading: false, user: user);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
