// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_testing_all/models/user_model.dart';
// import '../services/auth_remote_data_source.dart';

// class AuthRepository {
//   final AuthRemoteDataSource remote;

//   AuthRepository(this.remote);

//   Future<UserModel> login(String email, String password) async {
//     return await remote.login(email: email, password: password);
//   }

//   Future<UserModel> getProfile() async {
//     return await remote.getProfile();
//   }

//   Future<void> logout() async {
//     return await remote.logout();
//   }
// }

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   final remote = ref.watch(authRemoteDataSourceProvider);
//   return AuthRepository(remote);
// });
