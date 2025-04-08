import 'package:flutter/material.dart';
import '../widgets/goal_form.dart'; // не забудь создать и подключить форму!

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Map<String, dynamic>> goals = [];

  void _addGoal(Map<String, dynamic> newGoal) {
    setState(() {
      goals.add(newGoal);
    });
  }

  void _openGoalForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GoalForm(onSave: _addGoal), // ← передаём функцию добавления
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Goals')),
      body: goals.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("У тебя пока нет целей."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _openGoalForm,
              child: Text("Создать новую цель"),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: goals.length,
        itemBuilder: (ctx, i) {
          final goal = goals[i];
          return Card(
            child: ListTile(
              title: Text(goal['habit']),
              subtitle: Text(
                  "С ${goal['startDate']} по ${goal['endDate']} — ${goal['times']} раз"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openGoalForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
