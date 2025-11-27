import 'Order_item.dart';

class Order {
  final String id;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<OrderItem> orderItems = itemsJson
        .map((i) => OrderItem.fromJson(i))
        .toList();

    return Order(
      id: json['_id'] ?? json['id'], // Mongo sometimes sends _id
      items: orderItems,
      total: (json['total'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
