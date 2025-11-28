class Product {
  final String id;
  final String name;
  final double price;
  final String category;
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

  factory Product.fromJson(Map<String, dynamic> json) {
    String idValue = '';

    if (json['_id'] != null) {
      if (json['_id'] is String) {
        idValue = json['_id'];
      } else if (json['_id'] is Map && json['_id']['\$oid'] != null) {
        idValue = json['_id']['\$oid'];
      }
    } else if (json['id'] != null) {
      idValue = json['id'];
    } else if (json['productId'] != null) {
      // <-- NEW
      idValue = json['productId'];
    }

    return Product(
      id: idValue,
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      desc: json['desc'] ?? '',
      imageURL: json['imageURL'] ?? '',
    );
  }
}
