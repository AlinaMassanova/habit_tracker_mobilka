import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goal.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3001";

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

  static Future<http.Response> register(String name, String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
  }

  static Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
  }

  static Future<http.Response> logout(String token) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$token',
      },
    );
  }
}