import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _key = 'user_notifications';

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationsStr = prefs.getString(_key);
    
    if (notificationsStr == null) return [];
    
    List<dynamic> jsonList = jsonDecode(notificationsStr);
    return jsonList.map((e) => Map<String, dynamic>.from(e)).toList().reversed.toList();
  }

  static Future<void> addNotification(String title, String subtitle, String iconName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> currentNotifications = (await getNotifications()).reversed.toList();
    
    currentNotifications.add({
      'title': title,
      'subtitle': subtitle,
      'icon': iconName,
      'time': DateTime.now().toIso8601String(),
    });

    await prefs.setString(_key, jsonEncode(currentNotifications));
  }
}
