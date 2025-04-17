import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cat_tinder/data/models/cat.dart';
import 'package:flutter/material.dart';

class CatService {
  final String? apiKey = dotenv.env['API_KEY'];
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<List<Cat>> fetchRandomCats(int count) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?has_breeds=1&limit=$count&api_key=$apiKey'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => Cat.fromJson(json)).toList();
      } else {
        throw Exception('Не удалось загрузить котиков');
      }
    } catch (e, stackTrace) {
      debugPrint('Ошибка при загрузке котиков: $e');
      debugPrintStack(stackTrace: stackTrace);
      throw Exception('Не удалось загрузить котиков');
    }


  }
}
