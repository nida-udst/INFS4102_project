class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String desc;
  final String imageURL;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.desc,
    required this.imageURL,
  });

  //converts json
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      desc: json['desc'] ?? '',
      imageURL: json['imageURL'] ?? '',
    );
  }
}
