import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class PostStorage {
  static const String _storageKey = 'posts_list';

  // simpan posting ke penyimpanan lokal
  static Future<void> savePosts(List<PostModel> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = posts.map((post) => jsonEncode(post.toJson())).toList();
      await prefs.setStringList(_storageKey, jsonList);
    } catch (e) {
      print('Error saving posts: $e');
    }
  }

  // Load posting dari penyimpanan lokal
  static Future<List<PostModel>> loadPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_storageKey) ?? [];
      return jsonList.map((json) => PostModel.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      print('Error loading posts: $e');
      return [];
    }
  }

  // Clear semua posting dari penyimpanan lokal
  static Future<void> clearPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing posts: $e');
    }
  }
}
