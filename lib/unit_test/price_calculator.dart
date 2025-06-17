class PriceCalculator {
  double applyDiscount(
      {required double price, required double discountParcent}) {
    if (discountParcent < 0 || discountParcent > 100) {
      throw ArgumentError('Discount must be between 0 and 100');
    }
    return price - (price * (discountParcent / 100));
  }
}
