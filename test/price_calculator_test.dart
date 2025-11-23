import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_flow/unit_test/price_calculator.dart';

void main() {
  group("Price Calculator Test", () {
    final priceCalculator = PriceCalculator();

    test("should apply discount correctly", () {
      expect(
          priceCalculator.applyDiscount(price: 100, discountParcent: 10), 90);
    });

    test('zero discount returns original price', () {
      expect(
          priceCalculator.applyDiscount(price: 100, discountParcent: 0), 100);
    });

    test("should throw error for invalid discount", () {
      expect(
          () => priceCalculator.applyDiscount(price: 100, discountParcent: -10),
          throwsArgumentError);
      expect(
          () => priceCalculator.applyDiscount(price: 100, discountParcent: 120),
          throwsArgumentError);
    });
  });
}
