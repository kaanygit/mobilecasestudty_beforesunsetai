import 'package:beforesunsetai_mobile_case_study/model/task.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTask>(_onToggleTask);
    on<UpdateTask>(_onUpdateTask);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      final tasks = await taskRepository.loadTasks();
      emit(TaskLoaded(tasks));
    } catch (_) {
      emit(TaskError());
    }
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final List<Task> updatedTasks = List.from((state as TaskLoaded).tasks)
        ..add(Task(
          id: DateTime.now().toString(),
          name: event.name,
          description: event.description,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      await taskRepository.saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final updatedTasks = (state as TaskLoaded)
          .tasks
          .where((task) => task.id != event.id)
          .toList();
      await taskRepository.saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onToggleTask(ToggleTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final updatedTasks = (state as TaskLoaded)
          .tasks
          .map((task) {
            return task.id == event.id
                ? task.copyWith(isCompleted: !task.isCompleted)
                : task;
          })
          .whereType<Task>()
          .toList(); 
      await taskRepository.saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final updatedTasks = (state as TaskLoaded)
          .tasks
          .map((task) => task.id == event.task.id ? event.task : task)
          .toList();
      await taskRepository.saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    }
  }
}
