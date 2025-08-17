import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Fetch all tasks
  Future<void> fetchTasks(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.getTasks(token);
      _tasks = data.map<Task>((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add task
  Future<void> addTask(String title, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final json = await ApiService.createTask(title, token);
      _tasks.add(Task.fromJson(json));
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update task
  Future<void> updateTask(Task task, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final json = await ApiService.updateTask(task.id, {
        'completed': task.completed,
      }, token);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) _tasks[index] = Task.fromJson(json);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete task
  Future<void> deleteTask(String id, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.deleteTask(id, token);
      _tasks.removeWhere((t) => t.id == id);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
