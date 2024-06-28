import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beforesunsetai_mobile_case_study/bloc/task_bloc.dart';
import 'package:beforesunsetai_mobile_case_study/screens/add_task_screen.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/text_field.dart';
import 'mocks/mock_task_repository.dart';

void main() {
  group('AddTaskScreen', () {
    late TaskBloc taskBloc;
    late MockTaskRepository mockTaskRepository;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      taskBloc = TaskBloc(taskRepository: mockTaskRepository);
    });

    tearDown(() {
      taskBloc.close();
    });

    testWidgets('renders AddTaskScreen and widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => taskBloc,
            child: AddTaskScreen(),
          ),
        ),
      );

      expect(find.text('Add Task'), findsOneWidget);
      expect(find.byType(MyTextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsNWidgets(2));
      expect(find.text('Add Task'), findsOneWidget);

      await tester.enterText(find.byType(MyTextField).first, 'Test Task');
      expect(find.text('Test Task'), findsOneWidget);

      await tester.enterText(find.byType(MyTextField).last, 'Test Description');
      expect(find.text('Test Description'), findsOneWidget);

      await tester.tap(find.textContaining('Select Start Date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Select End Date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Task'));
      await tester.pumpAndSettle();

      final TaskState state = taskBloc.state;
      if (state is TaskLoaded) {
        expect(state.tasks.length, 1);
        expect(state.tasks.first.name, 'Test Task');
        expect(state.tasks.first.description, 'Test Description');
      } else {
        fail('TaskLoaded state not emitted');
      }
    });

    testWidgets('shows error snackbar when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => taskBloc,
            child: AddTaskScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Add Task'));
      await tester.pump();

      expect(find.text('Please enter all fields'), findsOneWidget);
    });
  });
}
