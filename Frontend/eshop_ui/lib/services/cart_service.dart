import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  final String baseUrl =
      'http://localhost:8080/cart'; // use 10.0.2.2 for Android emulator

  Future<Cart> getCart(String cartId) async {
    final response = await http.get(Uri.parse('$baseUrl/$cartId'));
    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  Future<Cart> addToCart(String cartId, String productId, int quantity) async {
    final url = Uri.parse('$baseUrl/$cartId/add/$productId?quantity=$quantity');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add product: ${response.statusCode}');
    }
  }

  Future<Cart> removeFromCart(String cartId, String productId) async {
    final url = Uri.parse('$baseUrl/$cartId/remove/$productId');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to remove product');
    }
  }

  Future<Cart> incrementQuantity(String cartId, String productId) async {
    final url = Uri.parse('$baseUrl/$cartId/increment/$productId');
    final response = await http.put(url);
    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to increment product');
    }
  }

  Future<Cart> decrementQuantity(String cartId, String productId) async {
    final url = Uri.parse('$baseUrl/$cartId/decrement/$productId');
    final response = await http.put(url);
    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to decrement product');
    }
  }

  Future<double> getTotal(String cartId) async {
    final url = Uri.parse('$baseUrl/$cartId/total');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to get cart total');
    }
  }
}
