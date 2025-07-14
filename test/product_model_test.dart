import 'package:flutter_test/flutter_test.dart';

import '../lib/unit_test/product_model.dart';

void main() {
  group("Product Model Parsing", () {
    final json = {
      'name': 'Test Product',
      'description': 'This is a test product.',
      'price': 100,
    };
    final productModel = ProductModel.fromJson(json);
    test("Product Model Parsing", () {
      expect(productModel.price, 100);
      expect(productModel.name, 'Test Product');
    });

    test("Should convert price double to int", () {
      final jsonWithDoublePrice = {
        'name': 'Test Product',
        'description': 'This is a test product.',
        'price': 99.99,
      };
      final productModelWithDoublePrice =
          ProductModel.fromJson(jsonWithDoublePrice);
      expect(productModelWithDoublePrice.price, 99);
    });

    test("should throw error if title is null", () {
      final jsonWithNullTitle = {
        'name': null,
        'description': 'This is a test product.',
        'price': 100,
      };

      expect(
        () => ProductModel.fromJson(jsonWithNullTitle),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
