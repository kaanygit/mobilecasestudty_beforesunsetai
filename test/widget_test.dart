import 'package:beforesunsetai_mobile_case_study/model/task.dart';
import 'package:beforesunsetai_mobile_case_study/repository/task_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beforesunsetai_mobile_case_study/bloc/task_bloc.dart';
import 'package:beforesunsetai_mobile_case_study/screens/home_screen.dart';
import 'package:beforesunsetai_mobile_case_study/screens/add_task_screen.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

void main() {
  group('HomeScreen', () {
    late MockTaskBloc mockTaskBloc;
    late MockTaskRepository mockTaskRepository;

    setUp(() async {
      mockTaskRepository = MockTaskRepository();
      mockTaskBloc = MockTaskBloc();

      SharedPreferences.setMockInitialValues({
        'username': 'Test User',
        'userImage': '',
      });
    });

    tearDown(() {
      mockTaskBloc.close();
    });

    testWidgets('renders HomeScreen and widgets', (WidgetTester tester) async {
      when(mockTaskBloc.state).thenReturn(TaskLoaded([]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (_) => mockTaskBloc,
            child: HomeScreen(),
          ),
        ),
      );

      expect(find.text('Hello, Test User'), findsOneWidget);
      expect(find.byType(EasyDateTimeLine), findsOneWidget);
      expect(find.text('No tasks for selected date'), findsOneWidget);

      final tasks = [
        Task(
            id: '1',
            name: 'Test Task',
            description: 'Test Description',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 1)),
            isCompleted: false),
      ];
      when(mockTaskBloc.state).thenReturn(TaskLoaded(tasks));

      mockTaskBloc.emit(TaskLoaded(tasks));
      await tester.pumpAndSettle();

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsOneWidget);
    });

    testWidgets('marks task as completed and deletes task',
        (WidgetTester tester) async {
      final task = Task(
          id: '1',
          name: 'Test Task',
          description: 'Test Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 1)),
          isCompleted: false);

      when(mockTaskBloc.state).thenReturn(TaskLoaded([task]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (_) => mockTaskBloc,
            child: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Task'), findsOneWidget);

      await tester.drag(find.text('Test Task'), Offset(500.0, 0.0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Complete'));
      await tester.pumpAndSettle();

      verify(mockTaskBloc.add(ToggleTask('1'))).called(1);

      await tester.drag(find.text('Test Task'), Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(mockTaskBloc.add(DeleteTask('1'))).called(1);
    });
  });
}
