import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  Future<void> put(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();

    final existingValues = prefs.getStringList(key) ?? [];

    final newValues = [
      ...existingValues,
      ...value.where((item) => !existingValues.contains(item))
    ];

    await prefs.setStringList(key, newValues);
  }

  Future<List<String>?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  Future<void> delete(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final existingValues = prefs.getStringList(key) ?? [];
    existingValues.remove(value);
    await prefs.setStringList(key, existingValues);
  }

  Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
