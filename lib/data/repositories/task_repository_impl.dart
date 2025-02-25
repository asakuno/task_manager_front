import 'package:dartz/dartz.dart' hide Task;

import '../../core/error/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final bool useLocalOnly; // Flag to use only local data (for now)

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.useLocalOnly = true, // Default to local only for now
  });

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final taskModels = await localDataSource.getTasks();
      // 明示的な型変換
      final List<Task> tasks = taskModels.map((model) => model as Task).toList();
      return Right(tasks);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(String id) async {
    try {
      final task = await localDataSource.getTaskById(id);
      return Right(task);
    } catch (e) {
      return Left(TaskNotFoundFailure(id));
    }
  }

  @override
  Future<Either<Failure, Task>> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final addedTask = await localDataSource.addTask(taskModel);
      return Right(addedTask);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final updatedTask = await localDataSource.updateTask(taskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      final result = await localDataSource.deleteTask(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}