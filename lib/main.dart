import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/usecases/usecase.dart';
import 'data/datasources/task_local_datasource.dart';
import 'data/datasources/task_remote_datasource.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/update_task.dart';
import 'presentation/blocs/task/task_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  // 日付のローカライズを初期化
  await initializeDateFormatting('ja_JP');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'タスク管理',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(
              getTasks: GetTasks(
                TaskRepositoryImpl(
                  localDataSource: TaskLocalDataSourceImpl(),
                  remoteDataSource: TaskRemoteDataSourceImpl(),
                ),
              ),
              addTask: AddTask(
                TaskRepositoryImpl(
                  localDataSource: TaskLocalDataSourceImpl(),
                  remoteDataSource: TaskRemoteDataSourceImpl(),
                ),
              ),
              updateTask: UpdateTask(
                TaskRepositoryImpl(
                  localDataSource: TaskLocalDataSourceImpl(),
                  remoteDataSource: TaskRemoteDataSourceImpl(),
                ),
              ),
            ),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}