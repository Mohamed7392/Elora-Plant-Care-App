import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use 10.0.2.2 for Android Emulator, or localhost/127.0.0.1 for Web/Windows
  final String baseUrl = 'http://127.0.0.1:5000/api/users';

  /// Get headers for requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  /// Create Account
  Future<Map<String, dynamic>?> createAccount({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: _headers,
        body: jsonEncode({
          'name': fullName.trim(),
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success']) {
        // Automatically login by saving the generated user ID as token
        await _saveToken(data['data']['_id']);
        return data['data'];
      } else {
        throw data['message'] ?? 'Failed to create account';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  /// Login
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        await _saveToken(data['data']['_id']);
        return data['data'];
      } else {
        throw data['message'] ?? 'Invalid credentials';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  /// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Get current user token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Save token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
