// lib/core/theme/provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Locale Provider (تم تعديله) ---
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar'); // اللغة الافتراضية هي العربية
  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocaleOrDefault();
  }

  /// يحمّل اللغة المحفوظة، أو يستخدم اللغة الافتراضية إذا لم توجد لغة محفوظة.
  Future<void> _loadSavedLocaleOrDefault() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');

    if (languageCode != null && ['ar', 'en'].contains(languageCode)) {
      _locale = Locale(languageCode);
    }
    // إذا لم توجد لغة محفوظة، ستبقى اللغة الافتراضية 'ar'
    notifyListeners();
  }

  /// يغير اللغة الحالية ويحفظها في الذاكرة.
  void setLocale(Locale newLocale) async {
    if (!['ar', 'en'].contains(newLocale.languageCode)) return;
    
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
    notifyListeners();
  }
}


// --- Theme Provider (تم تعديله) ---
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // ❌ تم حذف تعريفات الثيمات من هنا لاستخدام الملف المتخصص app_theme.dart

  ThemeProvider() {
    _loadTheme();
  }

  /// يغير بين الوضع المضيء والمظلم ويحفظ الاختيار.
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  /// يعيّن وضع الثيم (مظلم أو مضيء) ويحفظ الاختيار.
  void setTheme(bool isDark) async {
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  /// يحمّل إعدادات الثيم المحفوظة عند بدء التطبيق.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}