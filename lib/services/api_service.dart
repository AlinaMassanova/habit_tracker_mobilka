import 'package:habit_tracker/models/goal.dart';
import 'package:habit_tracker/services/api_dio.dart';

class ApiService {
  Future<List<Goal>> getUserGoals() async {
    final response = await ApiClient.dio.get('/goals');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Goal.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить цели: ${response.data['error'] ?? response.statusMessage}');
    }
  }

  Future<List<Habit>> getAvailableHabits() async {
    final response = await ApiClient.dio.get('/habits');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Habit.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить привычки: ${response.data['error'] ?? response.statusMessage}');
    }
  }

  Future<Goal> createGoal({
    required int habitId,
    required DateTime startDate,
    required DateTime endDate,
    required int targetCount,
  }) async {
    final response = await ApiClient.dio.post('/goals', data: {
      'habit_id': habitId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'target_count': targetCount,
    });

    if (response.statusCode == 201) {
      return Goal.fromJson(response.data);
    } else {
      throw Exception('Не удалось создать цель: ${response.data['error'] ?? response.statusMessage}');
    }
  }

  Future<void> logout() async {
    final response = await ApiClient.dio.post('/auth/logout');
    if (response.statusCode != 200) {
      throw Exception('Ошибка при выходе: ${response.data['error'] ?? response.statusMessage}');
    }
  }
}
