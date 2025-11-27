class Product {
  final String id;
  final String name;
  final double price;
  final String category; // "Equipment", "Nutrition", "Clothing", etc.
  final String desc;
  final String imageURL;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.desc,
    required this.imageURL,
  });

  // Converts JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      desc: json['desc'] ?? '',
      imageURL: json['imageURL'] ?? '',
    );
  }

  // Converts Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'desc': desc,
      'imageURL': imageURL,
    };
  }
}
