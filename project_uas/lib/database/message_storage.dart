import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';

class MessageStorage {
  // Save messages for a specific instructor
  static Future<void> saveMessages(String instructorName, List<Message> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'messages_$instructorName';
      final jsonList = messages.map((msg) => jsonEncode(msg.toJson())).toList();
      await prefs.setStringList(key, jsonList);
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  // Load messages for a specific instructor
  static Future<List<Message>> loadMessages(String instructorName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'messages_$instructorName';
      final jsonList = prefs.getStringList(key) ?? [];
      return jsonList.map((json) => Message.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      print('Error loading messages: $e');
      return [];
    }
  }

  // Get all conversations (instructors with messages)
  static Future<Map<String, List<Message>>> getAllConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final conversations = <String, List<Message>>{};

      for (final key in allKeys) {
        if (key.startsWith('messages_')) {
          final instructorName = key.replaceFirst('messages_', '');
          final jsonList = prefs.getStringList(key) ?? [];
          conversations[instructorName] =
              jsonList.map((json) => Message.fromJson(jsonDecode(json))).toList();
        }
      }

      return conversations;
    } catch (e) {
      print('Error loading conversations: $e');
      return {};
    }
  }

  // Clear messages for a specific instructor
  static Future<void> clearMessages(String instructorName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'messages_$instructorName';
      await prefs.remove(key);
    } catch (e) {
      print('Error clearing messages: $e');
    }
  }
}
