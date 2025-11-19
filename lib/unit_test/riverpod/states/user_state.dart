import 'package:equatable/equatable.dart';
import '../../../models/user_model.dart';

class UserState extends Equatable {
  final bool loading;
  final UserModel? user;
  final String? error;

  const UserState({
    this.loading = false,
    this.user,
    this.error,
  });

  UserState copyWith({
    bool? loading,
    UserModel? user,
    String? error,
  }) {
    return UserState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [loading, user, error];
}
