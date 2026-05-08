import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/auth_controller.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/services/task_service.dart';
import 'package:taskly/utils/app_formatters.dart';
import 'package:taskly/utils/app_snackbar.dart';

class TaskController extends GetxController {
  TaskController({
    required TaskService taskService,
    required AuthController authController,
  }) : _taskService = taskService,
       _authController = authController;

  final TaskService _taskService;
  final AuthController _authController;

  final tasks = <TaskModel>[].obs;
  final isLoading = true.obs;
  final isSaving = false.obs;
  final selectedCalendarDate = DateTime.now().obs;

  StreamSubscription<List<TaskModel>>? _taskSubscription;
  Worker? _authWorker;

  @override
  void onInit() {
    super.onInit();
    _authWorker = ever<User?>(_authController.firebaseUser, _listenToTasks);
    _listenToTasks(_authController.firebaseUser.value);
  }

  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => tasks.where((task) => !task.isCompleted).length;

  List<TaskModel> get todayTasks {
    final today = DateTime.now();
    return tasks
        .where((task) => AppFormatters.isSameDay(task.date, today))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<TaskModel> tasksForDate(DateTime date) {
    final filtered = tasks
        .where((task) => AppFormatters.isSameDay(task.date, date))
        .toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  TaskModel? findById(String? id) {
    if (id == null) {
      return null;
    }
    for (final task in tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  void _listenToTasks(User? user) {
    _taskSubscription?.cancel();

    if (user == null) {
      tasks.clear();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    _taskSubscription = _taskService
        .streamTasks(user.uid)
        .listen(
          (items) {
            tasks.assignAll(items);
            isLoading.value = false;
          },
          onError: (_) {
            isLoading.value = false;
            AppSnackbar.error('We could not load your tasks right now.');
          },
        );
  }

  Future<TaskModel?> saveTask({
    TaskModel? existingTask,
    required String title,
    required String description,
    required DateTime date,
    required String category,
  }) async {
    final user = _authController.firebaseUser.value;
    if (user == null) {
      AppSnackbar.error('Please sign in again to continue.');
      return null;
    }

    try {
      isSaving.value = true;

      final task =
          (existingTask ??
                  TaskModel(
                    title: title.trim(),
                    description: description.trim(),
                    date: date,
                    status: 'pending',
                    createdAt: DateTime.now(),
                    userId: user.uid,
                    category: category,
                  ))
              .copyWith(
                title: title.trim(),
                description: description.trim(),
                date: date,
                category: category,
              );

      if (existingTask == null) {
        final createdTask = await _taskService.createTask(user.uid, task);
        AppSnackbar.success('Task added to your planner.');
        return createdTask;
      }

      await _taskService.updateTask(user.uid, task);
      AppSnackbar.success('Task updated successfully.');
      return task;
    } catch (_) {
      AppSnackbar.error('We could not save your task right now.');
      return null;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    final user = _authController.firebaseUser.value;
    if (user == null) {
      return;
    }

    try {
      await _taskService.updateTask(
        user.uid,
        task.copyWith(status: task.isCompleted ? 'pending' : 'completed'),
      );
    } catch (_) {
      AppSnackbar.error('We could not update that task.');
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    final user = _authController.firebaseUser.value;
    if (user == null || task.id == null) {
      return;
    }

    try {
      await _taskService.deleteTask(user.uid, task.id!);
      AppSnackbar.success('Task removed.');
    } catch (_) {
      AppSnackbar.error('We could not delete that task.');
    }
  }

  @override
  void onClose() {
    _authWorker?.dispose();
    _taskSubscription?.cancel();
    super.onClose();
  }
}
