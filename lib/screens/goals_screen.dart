import 'package:flutter/material.dart';
import 'package:habit_tracker/services/api_service.dart';
import 'package:habit_tracker/models/goal.dart';
import 'package:habit_tracker/widgets/goal_form.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late Future<List<Goal>> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _refreshGoals();
  }

  void _refreshGoals() {
    setState(() {
      _goalsFuture = ApiService().getUserGoals();
    });
  }

  void _showAddGoalDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GoalForm(onGoalCreated: _refreshGoals),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои цели'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshGoals,
          ),
        ],
      ),
      body: FutureBuilder<List<Goal>>(
        future: _goalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('У тебя ещё нет целей'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showAddGoalDialog,
                    child: const Text('Создать первую цель'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final goal = snapshot.data![index];
                return _buildGoalCard(goal);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название и счёт
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.habit.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    '${goal.currentCount}/${goal.targetCount}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Привычка
            Text(
              'Привычка: ${goal.habit.name}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Даты
            Text(
              'Период: ${_formatDate(goal.startDate)} - ${_formatDate(goal.endDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Прогресс
            LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                goal.isCompleted ? Colors.green : Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(goal.progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
