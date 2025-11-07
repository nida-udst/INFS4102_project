import 'Product.dart';

class ClothingProduct extends Product {
  final String size;

  const ClothingProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.desc,
    required super.imageURL,
    required this.size,
  });

  //converts json
  factory ClothingProduct.fromJson(Map<String, dynamic> json) {
    return ClothingProduct(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      desc: json['desc'] ?? '',
      imageURL: json['imageURL'] ?? '',
      size: json['size'] ?? '',
    );
  }
}
