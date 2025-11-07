import 'Product.dart';

class AccessoryProduct extends Product {
  final String material;

  const AccessoryProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.desc,
    required super.imageURL,
    required this.material,
  });

  //converts json
  factory AccessoryProduct.fromJson(Map<String, dynamic> json) {
    return AccessoryProduct(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      desc: json['desc'] ?? '',
      imageURL: json['imageURL'] ?? '',
      material: json['material'] ?? '',
    );
  }
}
