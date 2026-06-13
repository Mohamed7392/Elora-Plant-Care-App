import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlantService {
  final String baseUrl = 'http://127.0.0.1:5000/api';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'x-user-id': token,
    };
  }

  // Gets all products (plants in the market)
  Future<List<Map<String, dynamic>>> getPlants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: await _getHeaders(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return (data['data'] as List).map((p) {
          p['id'] = p['_id']; // Map _id to id for UI
          return p as Map<String, dynamic>;
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting plants: $e');
      return [];
    }
  }

  Future<void> removeMyPlant(String docId) async {
    try {
      await http.delete(
        Uri.parse('$baseUrl/myplants/$docId'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      print('Error removing my plant: $e');
    }
  }

  Future<void> addMyPlants(List<String> plantIds, int wateringFrequencyHours) async {
    try {
      // The backend expects plantIds, frequency, and productsData (for name/image).
      // Let's fetch all plants first to send their data
      final allPlants = await getPlants();
      final productsData = allPlants
          .where((p) => plantIds.contains(p['id']))
          .map((p) => {'id': p['id'], 'name': p['name'], 'imageUrl': p['imageUrl']})
          .toList();

      await http.post(
        Uri.parse('$baseUrl/myplants'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'plantIds': plantIds,
          'wateringFrequencyHours': wateringFrequencyHours,
          'productsData': productsData,
        }),
      );
    } catch (e) {
      print('Error adding my plants: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMyPlants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/myplants'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((p) {
          return {
            'docId': p['_id'],
            'id': p['product'],
            'name': p['name'],
            'imageUrl': p['imageUrl'],
            'lastWateredAt': p['lastWateredAt'],
            'wateringFrequencyHours': p['wateringFrequencyHours'] ?? 24,
          };
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting my plants: $e');
      return [];
    }
  }
}
