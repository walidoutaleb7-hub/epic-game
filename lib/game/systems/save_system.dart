import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SaveSystem {
  static const String _key = 'epic_game_save';

  static Future<void> save({
    required int level,
    required int score,
    required int health,
    required List<String> inventory,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'level': level,
      'score': score,
      'health': health,
      'inventory': inventory,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await prefs.setString(_key, data);
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
