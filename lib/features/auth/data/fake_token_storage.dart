// test/fake_token_storage.dart
class FakeTokenStorage {
  String? _token;

  Future<void> saveToken(String token) async {
    _token = token;
  }

  Future<String?> getToken() async {
    return _token;
  }

  Future<void> clearToken() async {
    _token = null;
  }
}
