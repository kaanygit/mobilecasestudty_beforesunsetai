import 'dart:convert';
import 'package:beforesunsetai_mobile_case_study/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRepository {
  final String _tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_tasksKey);
    if (tasksString != null) {
      final List<dynamic> taskJsonList = json.decode(tasksString);
      return taskJsonList.map((json) => Task.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    final tasksString = json.encode(tasksJson);
    await prefs.setString(_tasksKey, tasksString);
  }
}
