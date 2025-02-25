import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTask implements UseCase<Task, AddTaskParams> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(AddTaskParams params) async {
    return await repository.addTask(params.task);
  }
}

class AddTaskParams extends Equatable {
  final Task task;

  const AddTaskParams(this.task);

  @override
  List<Object> get props => [task];
}