class Goal {
  final String habit;
  final DateTime startDate;
  final DateTime endDate;
  final int timesRequired;

  Goal({
    required this.habit,
    required this.startDate,
    required this.endDate,
    required this.timesRequired,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      habit: json['habit'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      timesRequired: json['times'],
    );
  }
}
