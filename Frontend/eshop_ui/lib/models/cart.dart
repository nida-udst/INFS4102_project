import 'cart_item.dart';

class Cart {
  final String id;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List?) ?? [];
    return Cart(
      id: json['_id'] ?? json['id'] ?? '',
      items: itemsJson.map((i) => CartItem.fromJson(i)).toList(),
    );
  }

  double get total => items.fold(
        0.0,
        (s, i) => s + (i.product.price * i.quantity),
      );
}
