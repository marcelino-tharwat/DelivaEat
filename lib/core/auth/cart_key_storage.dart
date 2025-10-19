import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class CartKeyStorage {
  static const String _key = 'cart_key';

  static Future<String> getOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    var val = prefs.getString(_key);
    if (val != null && val.isNotEmpty) return val;
    // lightweight pseudo-random key (no external deps)
    final rnd = Random();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final r1 = rnd.nextInt(1 << 32);
    final r2 = rnd.nextInt(1 << 32);
    val = 'ck_${ts.toRadixString(36)}_${r1.toRadixString(36)}${r2.toRadixString(36)}';
    await prefs.setString(_key, val);
    return val;
  }

  static Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
