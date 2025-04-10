import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/services/api_service.dart';
import 'package:habit_tracker/models/goal.dart';

class GoalForm extends StatefulWidget {
  final VoidCallback onGoalCreated;

  const GoalForm({super.key, required this.onGoalCreated});

  @override
  _GoalFormState createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  Habit? _selectedHabit;
  DateTime? _startDate;
  DateTime? _endDate;
  int _targetCount = 1;
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final api = ApiService();
      final habits = await api.getAvailableHabits();
      setState(() {
        _habits = habits;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при загрузке привычек: $e')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedHabit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выбери привычку')),
      );
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выбери даты')),
      );
      return;
    }

    try {
      final api = ApiService();
      await api.createGoal(
        habitId: _selectedHabit!.id,
        startDate: _startDate!,
        endDate: _endDate!,
        targetCount: _targetCount,
      );
      widget.onGoalCreated();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось создать цель: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Новая цель',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Habit>(
              value: _selectedHabit,
              decoration: const InputDecoration(
                labelText: 'Привычка',
                border: OutlineInputBorder(),
              ),
              items: _habits.map((habit) {
                return DropdownMenuItem<Habit>(
                  value: habit,
                  child: Text(habit.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHabit = value;
                });
              },
              validator: (value) {
                if (value == null) return 'Выберите привычку';
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Дата начала',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _startDate != null
                            ? DateFormat('dd.MM.yyyy').format(_startDate!)
                            : 'Выбрать дату',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Дата окончания',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _endDate != null
                            ? DateFormat('dd.MM.yyyy').format(_endDate!)
                            : 'Выбрать дату',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Сколько раз выполнить:',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: _targetCount.toDouble(),
              min: 1,
              max: 100,
              divisions: 99,
              label: '$_targetCount',
              onChanged: (value) {
                setState(() {
                  _targetCount = value.round();
                });
              },
            ),
            Center(
              child: Text(
                '$_targetCount раз',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text(
                    'Создать цель',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
