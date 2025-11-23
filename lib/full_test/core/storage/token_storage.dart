// import 'package:flutter_riverpod/flutter_riverpod.dart';

// abstract class TokenStorage {
//   Future<void> saveToken(String token);
//   Future<String?> getToken();
//   Future<void> clear();
// }

// class SecureTokenStorage implements TokenStorage {
//   // use flutter_secure_storage in production
//   @override
//   Future<void> saveToken(String token) async {/* real impl */}
//   @override
//   Future<String?> getToken() async => null;
//   @override
//   Future<void> clear() async {/* real impl */}
// }

// final tokenStorageProvider = Provider<TokenStorage>((ref) {
//   return SecureTokenStorage();
// });
