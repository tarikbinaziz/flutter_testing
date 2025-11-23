import 'package:equatable/equatable.dart';
import '../../../models/user_model.dart';

class AuthState extends Equatable {
  final bool loading;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.loading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? loading,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, user, error];
}
