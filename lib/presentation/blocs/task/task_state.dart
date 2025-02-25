import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TasksLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;

  const TasksLoaded(
    this.tasks, {
    this.statusFilter,
    this.priorityFilter,
  });

  List<Task> get filteredTasks {
    return tasks.where((task) {
      // Apply status filter if set
      if (statusFilter != null && task.status != statusFilter) {
        return false;
      }
      
      // Apply priority filter if set
      if (priorityFilter != null && task.priority != priorityFilter) {
        return false;
      }
      
      return true;
    }).toList();
  }

  @override
  List<Object> get props => [
    tasks,
    if (statusFilter != null) statusFilter!,
    if (priorityFilter != null) priorityFilter!,
  ];
}

class TaskLoaded extends TaskState {
  final Task task;

  const TaskLoaded(this.task);

  @override
  List<Object> get props => [task];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskAdded extends TaskState {
  final Task task;

  const TaskAdded(this.task);

  @override
  List<Object> get props => [task];
}

class TaskUpdated extends TaskState {
  final Task task;

  const TaskUpdated(this.task);

  @override
  List<Object> get props => [task];
}

class TaskDeleted extends TaskState {
  final String id;

  const TaskDeleted(this.id);

  @override
  List<Object> get props => [id];
}