import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'http://localhost:8080/eshop'; // backend URL

  // Fetch all products
  static Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/product-catalog'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch single product by ID
  static Future<Product> fetchProductById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/product-catalog/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return Product.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load product');
    }
  }
}
