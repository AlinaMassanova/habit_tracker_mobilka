import 'package:flutter/material.dart';

class GoalForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const GoalForm({super.key, required this.onSave});

  @override
  GoalFormState createState() => GoalFormState(); // без подчёркивания
}

class GoalFormState extends State<GoalForm> {  // без подчёркивания
  final _habitController = TextEditingController();
  final _timesController = TextEditingController();

  void _submit() {
    final habit = _habitController.text;
    final times = int.tryParse(_timesController.text) ?? 0;

    if (habit.isEmpty || times <= 0) return;

    final newGoal = {
      'habit': habit,
      'startDate': '2025-04-08', // временно
      'endDate': '2025-05-01',
      'times': times,
    };

    widget.onSave(newGoal); // вызываем переданную функцию
    Navigator.of(context).pop(); // закрываем форму
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Новая цель", style: TextStyle(fontSize: 18)),
          TextField(
            controller: _habitController,
            decoration: InputDecoration(labelText: 'Привычка'),
          ),
          TextField(
            controller: _timesController,
            decoration: InputDecoration(labelText: 'Сколько раз'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Создать'),
          ),
        ],
      ),
    );
  }
}
