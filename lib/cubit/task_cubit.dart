// lib/cubit/task_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TaskState {
  final List<Task> tasks;
  final bool isDarkMode;

  TaskState({required this.tasks, this.isDarkMode = false});

  TaskState copyWith({List<Task>? tasks, bool? isDarkMode}) => TaskState(
    tasks: tasks ?? this.tasks,
    isDarkMode: isDarkMode ?? this.isDarkMode,
  );
}

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState(tasks: []));

  final box = Hive.box('tasks');

  void loadTasks() {
    final rawList = box.get('tasks', defaultValue: []) as List;
    final taskList = rawList
        .whereType<Map>()
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    final isDark = box.get('isDarkMode', defaultValue: false);
    emit(state.copyWith(tasks: taskList, isDarkMode: isDark));
  }

  void addTask(String title) {
    final task = Task(id: const Uuid().v4(), title: title);
    final updated = [...state.tasks, task];
    _saveTasks(updated);
  }

  void toggleTask(String id) {
    final updated = state.tasks
        .map((t) => t.id == id ? t.copyWith(completed: !t.completed) : t)
        .toList();
    _saveTasks(updated);
  }

  void deleteTask(String id) {
    final updated = state.tasks.where((t) => t.id != id).toList();
    _saveTasks(updated);
  }

  void toggleTheme() {
    final newMode = !state.isDarkMode;
    box.put('isDarkMode', newMode);
    emit(state.copyWith(isDarkMode: newMode));
  }

  void _saveTasks(List<Task> tasks) {
    final mapped = tasks.map((t) => t.toMap()).toList();
    box.put('tasks', mapped);
    emit(state.copyWith(tasks: tasks));
  }
}
