import '../../domain/entities/task.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  /// Gets all tasks from the local cache
  Future<List<TaskModel>> getTasks();
  
  /// Gets a specific task by id from the local cache
  Future<TaskModel> getTaskById(String id);
  
  /// Adds a new task to the local cache
  Future<TaskModel> addTask(TaskModel task);
  
  /// Updates a task in the local cache
  Future<TaskModel> updateTask(TaskModel task);
  
  /// Deletes a task from the local cache
  Future<bool> deleteTask(String id);
  
  /// Caches the tasks received from the remote data source
  Future<void> cacheTasks(List<TaskModel> tasks);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  // For now, we'll use an in-memory store for mock data
  static final List<TaskModel> _mockTasks = [
    TaskModel(
      id: '1',
      title: 'Flutter UI実装',
      description: 'タスク管理アプリのUIを実装する',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: '2',
      title: 'バックエンド設計',
      description: 'バックエンドAPIの設計書を作成する',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      createdAt: DateTime.now(),
    ),
    TaskModel(
      id: '3',
      title: 'プロジェクト計画作成',
      description: '今後の開発スケジュールを作成する',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.high,
      status: TaskStatus.todo,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TaskModel(
      id: '4',
      title: 'デザインレビュー',
      description: 'UIデザインのレビューを行う',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<TaskModel>> getTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTasks;
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    final task = _mockTasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception('Task not found'),
    );
    return task;
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTasks.add(task);
    return task;
  }

  @override
  Future<TaskModel> updateTask(TaskModel updatedTask) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _mockTasks.indexWhere((task) => task.id == updatedTask.id);
    if (index == -1) {
      throw Exception('Task not found');
    }
    
    _mockTasks[index] = updatedTask;
    return updatedTask;
  }

  @override
  Future<bool> deleteTask(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final initialLength = _mockTasks.length;
    _mockTasks.removeWhere((task) => task.id == id);
    return _mockTasks.length < initialLength;
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    // In a real implementation, this would store tasks in shared preferences or a local database
    // For our mock, we'll just replace our in-memory list
    _mockTasks.clear();
    _mockTasks.addAll(tasks);
  }
}