class Goal {
  final int id;
  final Habit habit;
  final DateTime startDate;
  final DateTime endDate;
  final int targetCount;
  final int currentCount;
  final bool isCompleted;

  Goal({
    required this.id,
    required this.habit,
    required this.startDate,
    required this.endDate,
    required this.targetCount,
    required this.currentCount,
    required this.isCompleted,
  });

  double get progress => targetCount > 0 ? currentCount / targetCount : 0;

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: int.parse(json['id'].toString()),
      habit: Habit.fromJson(json['habit']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      targetCount: int.parse(json['target_count'].toString()),
      currentCount: int.parse(json['current_count'].toString()),
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
    );
  }
}

class Habit {
  final int id;
  final String name;
  final String color;
  final String? imageUrl;

  Habit({
    required this.id,
    required this.name,
    required this.color,
    this.imageUrl,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      color: json['color'],
      imageUrl: json['image_url'],
    );
  }
}