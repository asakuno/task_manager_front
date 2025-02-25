import 'package:dartz/dartz.dart' hide Task;
import '../entities/task.dart';
import '../../core/error/failures.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();

  Future<Either<Failure, Task>> getTaskById(String id);

  Future<Either<Failure, Task>> addTask(Task task);

  Future<Either<Failure, Task>> updateTask(Task task);

  Future<Either<Failure, bool>> deleteTask(String id);
}