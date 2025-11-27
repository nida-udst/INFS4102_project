import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CartManager {
  static const _key = 'local_cart_id';

  /// Get existing cartId or create a new one
  static Future<String> getOrCreateCartId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = const Uuid().v4();
    await prefs.setString(_key, id);
    return id;
  }

  /// Clear the cart ID
  static Future<void> clearCartId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static const _userKey = 'user_id';

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
}
