// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cubit/task_cubit.dart';
import 'screens/task_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('tasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit()..loadTasks(),
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Task Manager',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const TaskPage(),
          );
        },
      ),
    );
  }
}
