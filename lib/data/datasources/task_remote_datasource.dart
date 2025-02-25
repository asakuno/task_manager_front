import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  /// Gets all tasks from the API
  Future<List<TaskModel>> getTasks();
  
  /// Gets a specific task by id from the API
  Future<TaskModel> getTaskById(String id);
  
  /// Adds a new task through the API
  Future<TaskModel> addTask(TaskModel task);
  
  /// Updates a task through the API
  Future<TaskModel> updateTask(TaskModel task);
  
  /// Deletes a task through the API
  Future<bool> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  // In a real implementation, this would use http or dio to make API calls
  // For now, we'll throw a not implemented exception as we're focusing on UI with mock data
  
  @override
  Future<List<TaskModel>> getTasks() async {
    throw UnimplementedError('Remote data source not implemented yet');
  }
  
  @override
  Future<TaskModel> getTaskById(String id) async {
    throw UnimplementedError('Remote data source not implemented yet');
  }
  
  @override
  Future<TaskModel> addTask(TaskModel task) async {
    throw UnimplementedError('Remote data source not implemented yet');
  }
  
  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    throw UnimplementedError('Remote data source not implemented yet');
  }
  
  @override
  Future<bool> deleteTask(String id) async {
    throw UnimplementedError('Remote data source not implemented yet');
  }
}