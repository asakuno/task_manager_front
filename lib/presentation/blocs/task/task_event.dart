import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasksEvent extends TaskEvent {
  const GetTasksEvent();
}

class GetTaskByIdEvent extends TaskEvent {
  final String id;

  const GetTaskByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;

  const DeleteTaskEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FilterTasksEvent extends TaskEvent {
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;

  const FilterTasksEvent({this.statusFilter, this.priorityFilter});

  @override
  List<Object> get props => [
    if (statusFilter != null) statusFilter!,
    if (priorityFilter != null) priorityFilter!,
  ];
}