import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  late final String name;
  late final String description;
  late final DateTime startDate;
  late final DateTime endDate;
  late final bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, description, startDate, endDate, isCompleted];
}
