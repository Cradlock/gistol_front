import 'package:flutter/material.dart';
import 'package:app_front/features/tasks/domain/errors.dart';
import 'package:app_front/features/tasks/domain/task.dart';
import 'package:app_front/features/tasks/services/tasks_service.dart';

class TasksProvider extends ChangeNotifier {
  final TasksService _service = TasksService();

  static const int pageSize = 20;

  List<StudentTask> tasks = [];
  List<TaskHistoryItem> history = [];

  bool isTasksLoading = false;
  bool isSubmitting = false;
  bool isHistoryLoading = false;
  bool hasMoreTasks = true;
  bool hasMoreHistory = true;

  int _tasksPage = 1;
  int _historyPage = 1;

  Future<void> fetchTasks({bool refresh = false}) async {
    if (isTasksLoading || (!refresh && !hasMoreTasks)) return;
    if (refresh) {
      _tasksPage = 1;
      hasMoreTasks = true;
    }

    isTasksLoading = true;
    notifyListeners();
    try {
      final response = await _service.getAvailableTasks(
        page: _tasksPage,
        pageSize: pageSize,
      );
      final data = response.data!;
      tasks = refresh ? data.tasks : [...tasks, ...data.tasks];
      hasMoreTasks = tasks.length < data.total;
      if (hasMoreTasks) _tasksPage++;
    } finally {
      isTasksLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAnswer(StudentTask task, String text) async {
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();
    try {
      await _service.submitAnswer(task.id, TaskAnswerRequest(text.trim()));
      tasks.removeWhere((item) => item.id == task.id);
      history = [];
      _historyPage = 1;
      hasMoreHistory = true;
    } on TaskAlreadyAnsweredException {
      tasks.removeWhere((item) => item.id == task.id);
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory({bool refresh = false}) async {
    if (isHistoryLoading || (!refresh && !hasMoreHistory)) return;
    if (refresh) {
      _historyPage = 1;
      hasMoreHistory = true;
    }

    isHistoryLoading = true;
    notifyListeners();
    try {
      final response = await _service.getHistory(
        page: _historyPage,
        pageSize: pageSize,
      );
      final data = response.data!;
      history = refresh ? data.answers : [...history, ...data.answers];
      hasMoreHistory = history.length < data.total;
      if (hasMoreHistory) _historyPage++;
    } finally {
      isHistoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreTasks(ScrollController controller) async {
    if (!controller.hasClients || !hasMoreTasks || isTasksLoading) return;
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 120) {
      await fetchTasks();
    }
  }

  Future<void> loadMoreHistory(ScrollController controller) async {
    if (!controller.hasClients || !hasMoreHistory || isHistoryLoading) return;
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 120) {
      await fetchHistory();
    }
  }
}
