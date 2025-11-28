import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://localhost:8080/orders';

  Future<Order> placeOrder(String userEmail, String paymentMethod) async {
    final response = await http.post(
      Uri.parse('$baseUrl/place/$userEmail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'paymentMethod': paymentMethod}),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to place order');
    }
  }

  Future<List<Order>> getAllOrders() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<Order>> getOrdersByEmail(String userEmail) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      List<Order> allOrders = jsonList
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
      return allOrders.where((order) => order.userEmail == userEmail).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> updateOrderStatus(String orderId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$orderId/status?status=$status'),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update order status');
    }
  }
}
