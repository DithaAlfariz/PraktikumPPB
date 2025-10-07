import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ResepDataMinuman {
  static const _key = 'resep_list_minuman';

  static Future<List<Map<String, dynamic>>> getResepList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> decoded = json.decode(jsonString);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> saveResepList(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list);
    await prefs.setString(_key, jsonString);
  }
}