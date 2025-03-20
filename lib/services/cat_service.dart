// lib/services/cat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat.dart';

class CatService {
  static const String apiKey = 'live_m4eU8d8o2QkryB1715g02aEt0sgl8Qiaf168ZLYWLt0dN6qx4IJZuRTC6gY6RrhF';
  static const String baseUrl = 'https://api.thecatapi.com/v1/images/search';

  Future<List<Cat>> fetchRandomCats(int count) async {
    final response = await http.get(
      Uri.parse('$baseUrl?has_breeds=1&limit=$count&api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Cat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cats');
    }
  }
}