part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  const AddTask({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [name, description, startDate, endDate];
}

class DeleteTask extends TaskEvent {
  final String id;

  const DeleteTask(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleTask extends TaskEvent {
  final String id;

  const ToggleTask(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}
