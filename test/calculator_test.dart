import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_all/unit_test/calculator.dart';

void main() {
  group("Calculator Test", () {
    final calculator = Calculator();

    test("should return sum of two numbers", () {
      expect(calculator.add(2, 3), 5);
    });
    test("should return difference of two numbers", () {
      expect(calculator.subtract(5, 3), 2);
    });
  });
}
