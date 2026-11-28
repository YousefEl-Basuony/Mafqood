import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and notifies theme mode, language (AR/EN), and notification preferences.
class AppSettingsManager extends ChangeNotifier {
  static const _keyThemeDark = 'mafqood_dark_mode';
  static const _keyLangCode = 'mafqood_lang_code';
  static const _keyNotifEnabled = 'mafqood_notif_enabled';

  bool _isDarkMode = false;
  String _languageCode = 'ar';
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);
  bool get isArabic => _languageCode == 'ar';
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_keyThemeDark) ?? false;
    _languageCode = prefs.getString(_keyLangCode) ?? 'ar';
    _notificationsEnabled = prefs.getBool(_keyNotifEnabled) ?? true;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyThemeDark, value);
  }

  Future<void> setLanguage(String code) async {
    if (_languageCode == code) return;
    _languageCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLangCode, code);
  }

  Future<void> toggleLanguage() async {
    await setLanguage(isArabic ? 'en' : 'ar');
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifEnabled, value);
  }
}
