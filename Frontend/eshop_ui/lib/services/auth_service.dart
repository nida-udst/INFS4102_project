import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8080/auth';

  // Login: returns user id or token
  Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final userId = res.body;
      // Save login state locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      return userId;
    } else {
      throw Exception('Invalid email or password'); // simplified message
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
      throw Exception('Failed to register: ${res.body}');
    }
  }

  // Logout: clear stored user session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}
