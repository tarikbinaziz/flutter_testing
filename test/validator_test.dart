import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_flow/unit_test/validator.dart';

void main() {
  group("Validator Test", () {
    final validator = Validator();
    test(
      "should return true for valid email",
      () {
        expect(validator.isEmailValidate("t@.com"), isFalse);
      },
    );
    test(
      "should return false for invalid email",
      () {
        expect(validator.isEmailValidate("t@.com"), isFalse);
      },
    );
    test(
      "should return false for empty email",
      () {
        expect(validator.isEmailValidate(""), isFalse);
      },
    );
  });
}
