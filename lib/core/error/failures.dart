import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {
  @override
  List<Object> get props => [];
}

// Domain specific failures
class InvalidTaskFailure extends Failure {
  final String message;

  const InvalidTaskFailure(this.message);

  @override
  List<Object> get props => [message];
}

class TaskNotFoundFailure extends Failure {
  final String id;

  const TaskNotFoundFailure(this.id);

  @override
  List<Object> get props => [id];
}