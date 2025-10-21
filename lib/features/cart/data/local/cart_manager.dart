import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deliva_eat/features/cart/ui/widgets/cart_item_card.dart';

class CartManager {
  static const String _cartKey = 'guest_cart';

  static Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(items.map((item) => _cartItemToJson(item)).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  static Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    if (cartJson == null) return [];
    final List<dynamic> decoded = jsonDecode(cartJson);
    return decoded.map((item) => _cartItemFromJson(item)).toList();
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  static Future<void> addItem(CartItem item) async {
    final items = await loadCart();
    final existingIndex = items.indexWhere((i) => i.id == item.id);
    if (existingIndex != -1) {
      items[existingIndex].quantity += item.quantity;
    } else {
      items.add(item);
    }
    await saveCart(items);
  }

  static Future<void> updateQuantity(String id, int quantity) async {
    final items = await loadCart();
    final index = items.indexWhere((i) => i.id == id);
    if (index != -1) {
      items[index].quantity = quantity;
      await saveCart(items);
    }
  }

  static Future<void> removeItem(String id) async {
    final items = await loadCart();
    items.removeWhere((i) => i.id == id);
    await saveCart(items);
  }

  static Map<String, dynamic> _cartItemToJson(CartItem item) {
    return {
      'id': item.id,
      'name': item.name,
      'image': item.image,
      'price': item.price,
      'quantity': item.quantity,
      'addons': item.addons.map((addon) => {
        'id': addon.id,
        'name': addon.name,
        'image': addon.image,
        'price': addon.price,
      }).toList(),
    };
  }

  static CartItem _cartItemFromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
      addons: (json['addons'] as List<dynamic>).map((addon) => AddonItem(
        id: addon['id'],
        name: addon['name'],
        image: addon['image'],
        price: addon['price'],
      )).toList(),
    );
  }
}
