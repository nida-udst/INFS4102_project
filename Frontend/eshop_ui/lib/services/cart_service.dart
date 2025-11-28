import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  final String baseUrl = "http://localhost:8080/cart";

  Future<Cart> getCart(String userEmail) async {
    final url = Uri.parse("$baseUrl/$userEmail");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  /// Explicit create cart (called after login)
  Future<Cart> createCart(String email) async {
    final res = await http.post(Uri.parse('$baseUrl/$email/create'));

    if (res.statusCode == 200) {
      return Cart.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to create cart: ${res.statusCode}");
    }
  }

  /// Add product OR increase quantity
  Future<Cart> addToCart(String email, String productId, int qty) async {
    final res = await http.post(
      Uri.parse('$baseUrl/$email/add/$productId?quantity=$qty'),
    );

    if (res.statusCode == 200) {
      return Cart.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to add item: ${res.statusCode}");
    }
  }

  /// Increment product quantity by 1
  Future<Cart> incrementQuantity(String email, String productId) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$email/increment/$productId'),
    );

    if (res.statusCode == 200) {
      return Cart.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to increment: ${res.statusCode}");
    }
  }

  /// Decrement product quantity by 1
  Future<Cart> decrementQuantity(String email, String productId) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$email/decrement/$productId'),
    );

    if (res.statusCode == 200) {
      return Cart.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to decrement: ${res.statusCode}");
    }
  }

  /// Remove product completely
  Future<Cart> removeFromCart(String email, String productId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/$email/remove/$productId'),
    );

    if (res.statusCode == 200) {
      return Cart.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to remove product: ${res.statusCode}");
    }
  }

  /// Clear cart
  Future<Cart> clearCart(String email) async {
    final url = Uri.parse("$baseUrl/$email/clear");
    final response = await http.post(url);

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to clear cart');
    }
  }

  /// Calculate total from backend
  Future<double> getTotalCost(String email) async {
    final res = await http.get(Uri.parse('$baseUrl/$email/total'));

    if (res.statusCode == 200) {
      return double.tryParse(res.body) ?? 0.0;
    } else {
      throw Exception("Failed to get total: ${res.statusCode}");
    }
  }
}
