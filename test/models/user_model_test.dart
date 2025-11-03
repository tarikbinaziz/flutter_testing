import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_flow/models/user_model.dart';

void main() {
  group('UserModel JSON Test', () {
    test('fromJson should parse correctly', () {
      final json = {
        "id": 1,
        "name": "Tarik",
        "email": "tarik@example.com",
        "balance": 120.50
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, "Tarik");
      expect(user.email, "tarik@example.com");
      expect(user.balance, 120.50);
    });

    test('toJson should convert model to map', () {
      final user = UserModel(
        id: 2,
        name: "Razin",
        email: null,
        balance: 80.0,
      );

      final json = user.toJson();

      expect(json["id"], 2);
      expect(json["name"], "Razin");
      expect(json["email"], null);
      expect(json["balance"], 80.0);
    });

    test('should throw error when type mismatch occurs', () {
      final json = {
        "id": "one", // ❌ wrong type (string instead of int)
        "name": "Test",
        "balance": 50.0
      };

      expect(() => UserModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
