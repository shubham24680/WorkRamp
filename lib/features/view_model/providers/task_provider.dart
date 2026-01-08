import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tickit/features/model/task.dart';

import '../../../core/services/task_curd.dart';

class TaskProvider extends ChangeNotifier {
  final TaskDB _db = TaskDB();
  List<Task> _allTasks = [];
  TextEditingController taskController = TextEditingController();
  bool _isButtonEnabled = false;
  int selectedIndex = -1;
  bool isLoading = false;

  List<Task> get allTasks => _allTasks;
  bool get isButtonEnabled => _isButtonEnabled;

  // Create
  void addTask() async {
    final response = await _db.create(taskController.text.trim(), null);
    if (response != null) {
      log("message successful");
      _allTasks.insert(
          0, Task.fromJson(response.first as Map<String, dynamic>));
    }
    notifyListeners();
  }

  // Update
  void updateTask() async {
    _allTasks[selectedIndex].task = taskController.text;
    await _db.update(_allTasks[selectedIndex]);
    selectedIndex = -1;
    notifyListeners();
  }

  // Read
  void fetchTask() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _db.read();
      if (response != null) {
        _allTasks =
            (response as List).map((task) => Task.fromJson(task)).toList();
        rearrangeTasks();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delete
  void removeTask(BuildContext context, int index) async {
    await _db.delete(_allTasks[index]);
    _allTasks.removeAt(index);
    notifyListeners();
    if (context.mounted) {
      log("checking deletion");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully deleted."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Checkbox toggle
  void changeCheckBox(int index) async {
    _allTasks[index].isCompleted = !_allTasks[index].isCompleted;
    await _db.update(_allTasks[index]);
    rearrangeTasks();
    notifyListeners();
  }

  void rearrangeTasks() {
    for (int i = _allTasks.length - 1; i >= 0; i--) {
      Task tempTask = _allTasks[i];
      if (tempTask.isCompleted) {
        int j = i + 1;
        while (j < _allTasks.length && !_allTasks[j].isCompleted) {
          _allTasks[j - 1] = _allTasks[j];
          j++;
        }
        _allTasks[j - 1] = tempTask;
      }
    }
  }

  // Check editor(text field) is not empty.
  void onChanged(bool value) {
    _isButtonEnabled = value;
    notifyListeners();
  }

  void clearTask() {
    log("clear Task");
    _allTasks.clear();
    notifyListeners();
  }
}
