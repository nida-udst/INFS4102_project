import 'Product.dart';

class NutritionProduct extends Product {
  final double weightKg;
  final double calories;

  const NutritionProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.desc,
    required super.imageURL,
    required this.weightKg,
    required this.calories,
  });

  //converts json
  factory NutritionProduct.fromJson(Map<String, dynamic> json) {
    return NutritionProduct(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      desc: json['desc'] ?? '',
      imageURL: json['imageURL'] ?? '',
      weightKg: (json['weightKg'] ?? 0).toDouble(),
      calories: (json['calories'] ?? 0).toDouble(),
    );
  }
}
