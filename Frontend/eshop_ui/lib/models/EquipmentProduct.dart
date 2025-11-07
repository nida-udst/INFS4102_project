import 'Product.dart';

class EquipmentProduct extends Product {
  final double weightKg;
  final String dimensions;

  const EquipmentProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.desc,
    required super.imageURL,
    required this.weightKg,
    required this.dimensions,
  });

  //converts json
  factory EquipmentProduct.fromJson(Map<String, dynamic> json) {
    return EquipmentProduct(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      desc: json['desc'] ?? '',
      imageURL: json['imageURL'] ?? '',
      weightKg: (json['weightKg'] ?? 0).toDouble(),
      dimensions: json['dimensions'] ?? '',
    );
  }
}
