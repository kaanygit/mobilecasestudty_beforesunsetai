import 'package:beforesunsetai_mobile_case_study/screens/intro_dialog_screen.dart';
import 'package:beforesunsetai_mobile_case_study/screens/privacy_policy_screen.dart';
import 'package:beforesunsetai_mobile_case_study/screens/terms_of_use_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'repository/task_repository.dart';
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  final TaskRepository taskRepository = TaskRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) =>
              TaskBloc(taskRepository: taskRepository)..add(LoadTasks()),
        ),
      ],
      child: MaterialApp(
        title: 'To-do App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => IntroScreen(),
          '/home': (context) => HomeScreen(),
          '/add_task': (context) => AddTaskScreen(),
          '/privacy_policy': (context) => PrivacyPolicyScreen(),
          '/terms_of_use': (context) => TermsOfUseScreen(),
          '/intro_dialog': (context) => IntroDialog(),
        },
      ),
    );
  }
}
