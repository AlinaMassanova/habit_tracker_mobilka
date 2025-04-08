import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goal.dart'; // не забудь создать этот файл и класс Goal

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3001"; // если эмулятор

  static Future<List<Goal>> fetchGoals(String token) async {
    final url = Uri.parse('$baseUrl/goals');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Goal.fromJson(item)).toList();
    } else {
      throw Exception('Не удалось загрузить цели');
    }
  }
}
