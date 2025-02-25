import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskTap;
  final Function(Task, bool?) onTaskStatusChanged;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'タスクがありません',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(
          task: task,
          onTap: () => onTaskTap(task),
          onStatusChanged: (checked) => onTaskStatusChanged(task, checked),
        );
      },
    );
  }
}