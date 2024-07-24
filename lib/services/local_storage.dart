import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveData(String key, dynamic value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else {
        throw Exception("Invalid type");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving data: $e");
      }
    }
  }

  static Future<dynamic> getData(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.get(key);
    } catch (e) {
      if (kDebugMode) {
        print("Error getting data: $e");
      }
      return null;
    }
  }

  static Future<void> removeData(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      if (kDebugMode) {
        print("Error removing data: $e");
      }
    }
  }

   static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}

 
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorageService {
//   static Future<void> saveData(String key, String value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key, value);
//   }

//   static Future<String?> getData(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }

//   static Future<void> removeData(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove(key);
//   }
// }