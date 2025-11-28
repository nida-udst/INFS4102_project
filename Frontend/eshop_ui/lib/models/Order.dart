import 'Order_item.dart';

class Order {
  final String id;
  final String userEmail;
  final String paymentMethod;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userEmail,
    required this.paymentMethod,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List? ?? [];
    List<OrderItem> orderItems = itemsJson
        .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
        .toList();

    return Order(
      id: json['_id'] ?? json['id'] ?? '',
      userEmail: json['userEmail'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Unknown',
      items: orderItems,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }
}
