// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Save any Map object (JSON-style) to local storage under a custom key
  static Future<void> saveData(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }

  /// Get stored Map object by key
  static Future<Map<String, dynamic>?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  /// Save a simple string value
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Get a simple string value
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Remove any data by key
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Clear all saved data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
