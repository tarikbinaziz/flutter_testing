class ProductModel {
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}