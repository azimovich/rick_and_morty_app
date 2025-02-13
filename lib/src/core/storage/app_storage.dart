import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey { accessToken, refreshToken, isBlocked }

class AppStorage {
  factory AppStorage() => _service;

  AppStorage._internal();

  static final AppStorage _service = AppStorage._internal();

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<String?> $read({required StorageKey key}) async {
    final prefs = await _getPrefs();
    return prefs.getString(key.name);
  }

  static Future<void> $write({required StorageKey key, required String value}) async {
    final prefs = await _getPrefs();
    await prefs.setString(key.name, value);
  }

  static Future<bool?> $readBool({required StorageKey key}) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key.name);
  }

  static Future<void> $writeBool({required StorageKey key, required bool value}) async {
    final prefs = await _getPrefs();
    await prefs.setBool(key.name, value);
  }

  static Future<void> clearAllData() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  static Future<void> $delete({required StorageKey key}) async {
    final prefs = await _getPrefs();
    await prefs.remove(key.name);
  }
}
