import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/cart_manager.dart';
import 'cart_service.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8080/auth';
  final CartService _cartService = CartService();

  // Login: returns user id, stores email and creates cart
  Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final userId = res.body;

      // Store user email (used as cart id)
      await CartManager.setUserEmail(email);
      await CartManager.setUserId(userId);

      // Create cart with email as id
      await _cartService.createCart(email);

      return userId;
    } else {
      throw Exception('Login failed: ${res.statusCode}');
    }
  }

  // Register a new user
  Future<void> register(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) {
      throw Exception('Registration failed: ${res.statusCode}');
    }
  }

  // Logout: clear stored user session and cart
  Future<void> logout() async {
    await CartManager.clearUserData();
  }
}
