import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/usecases/add_task.dart';
import '../../../domain/usecases/get_tasks.dart';
import '../../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
  }) : super(TaskInitial()) {
    on<GetTasksEvent>(_onGetTasksEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<FilterTasksEvent>(_onFilterTasksEvent);
  }

  Future<void> _onGetTasksEvent(
    GetTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TasksLoading());
    
    final result = await getTasks(NoParams());
    
    result.fold(
      (failure) => emit(TaskError('Failed to load tasks')),
      (List<Task> tasks) => emit(TasksLoaded(tasks)),
    );
  }

  Future<void> _onAddTaskEvent(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TasksLoading());
    
    final result = await addTask(AddTaskParams(event.task));
    
    result.fold(
      (failure) => emit(TaskError('Failed to add task')),
      (task) {
        emit(TaskAdded(task));
        add(const GetTasksEvent()); // Refresh the task list
      },
    );
  }

  Future<void> _onUpdateTaskEvent(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TasksLoading());
    
    final result = await updateTask(UpdateTaskParams(event.task));
    
    result.fold(
      (failure) => emit(TaskError('Failed to update task')),
      (task) {
        emit(TaskUpdated(task));
        add(const GetTasksEvent()); // Refresh the task list
      },
    );
  }

  Future<void> _onFilterTasksEvent(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is TasksLoaded) {
      emit(TasksLoaded(
        currentState.tasks,
        statusFilter: event.statusFilter,
        priorityFilter: event.priorityFilter,
      ));
    } else {
      // If not already loaded, load tasks first then apply filter
      add(const GetTasksEvent());
    }
  }
}