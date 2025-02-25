import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import '../blocs/task/task_state.dart';
import '../widgets/task_list.dart';
import 'task_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const GetTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タスク管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TasksLoaded) {
            final tasks = state.filteredTasks;
            return Column(
              children: [
                if (_statusFilter != null || _priorityFilter != null)
                  _buildActiveFilters(),
                Expanded(
                  child: TaskList(
                    tasks: tasks,
                    onTaskTap: _navigateToTaskDetail,
                    onTaskStatusChanged: _updateTaskStatus,
                  ),
                ),
              ],
            );
          } else if (state is TaskError) {
            return Center(child: Text('エラー: ${state.message}'));
          } else {
            return const Center(child: Text('タスクを読み込んでいます...'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTask,
        tooltip: '新しいタスク',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToTaskDetail(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(task: task),
      ),
    );

    if (result == true) {
      // Task was updated, refresh list
      if (!mounted) return;
      context.read<TaskBloc>().add(GetTasksEvent());
    }
  }

  void _createNewTask() async {
    // Create an empty task with a new UUID
    final newTask = Task(
      id: const Uuid().v4(),
      title: '',
      description: '',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      createdAt: DateTime.now(),
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(
          task: newTask,
          isNewTask: true,
        ),
      ),
    );

    if (result == true) {
      // New task was added, refresh list
      if (!mounted) return;
      context.read<TaskBloc>().add(GetTasksEvent());
    }
  }

  void _updateTaskStatus(Task task, bool? checked) {
    if (checked == null) return;

    final updatedTask = task.copyWith(
      status: checked ? TaskStatus.completed : TaskStatus.todo,
      updatedAt: DateTime.now(),
    );

    context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TaskStatus? tempStatusFilter = _statusFilter;
        TaskPriority? tempPriorityFilter = _priorityFilter;

        return AlertDialog(
          title: const Text('フィルター'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ステータス'),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(
                        label: '未着手',
                        selected: tempStatusFilter == TaskStatus.todo,
                        onSelected: (selected) {
                          setState(() {
                            tempStatusFilter = selected ? TaskStatus.todo : null;
                          });
                        },
                      ),
                      _buildFilterChip(
                        label: '進行中',
                        selected: tempStatusFilter == TaskStatus.inProgress,
                        onSelected: (selected) {
                          setState(() {
                            tempStatusFilter = selected ? TaskStatus.inProgress : null;
                          });
                        },
                      ),
                      _buildFilterChip(
                        label: '完了',
                        selected: tempStatusFilter == TaskStatus.completed,
                        onSelected: (selected) {
                          setState(() {
                            tempStatusFilter = selected ? TaskStatus.completed : null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('優先度'),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(
                        label: '高',
                        selected: tempPriorityFilter == TaskPriority.high,
                        onSelected: (selected) {
                          setState(() {
                            tempPriorityFilter = selected ? TaskPriority.high : null;
                          });
                        },
                      ),
                      _buildFilterChip(
                        label: '中',
                        selected: tempPriorityFilter == TaskPriority.medium,
                        onSelected: (selected) {
                          setState(() {
                            tempPriorityFilter = selected ? TaskPriority.medium : null;
                          });
                        },
                      ),
                      _buildFilterChip(
                        label: '低',
                        selected: tempPriorityFilter == TaskPriority.low,
                        onSelected: (selected) {
                          setState(() {
                            tempPriorityFilter = selected ? TaskPriority.low : null;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _statusFilter = tempStatusFilter;
                  _priorityFilter = tempPriorityFilter;
                });
                
                context.read<TaskBloc>().add(FilterTasksEvent(
                  statusFilter: _statusFilter,
                  priorityFilter: _priorityFilter,
                ));
                
                Navigator.pop(context);
              },
              child: const Text('適用'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _statusFilter = null;
                  _priorityFilter = null;
                });
                
                context.read<TaskBloc>().add(const FilterTasksEvent());
                
                Navigator.pop(context);
              },
              child: const Text('クリア'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 16),
          const SizedBox(width: 8),
          const Text('絞り込み:'),
          const SizedBox(width: 8),
          if (_statusFilter != null)
            _buildActiveFilterChip(
              label: _statusFilter == TaskStatus.todo
                  ? '未着手'
                  : _statusFilter == TaskStatus.inProgress
                      ? '進行中'
                      : '完了',
              onDeleted: () {
                setState(() {
                  _statusFilter = null;
                });
                context.read<TaskBloc>().add(FilterTasksEvent(
                  statusFilter: null,
                  priorityFilter: _priorityFilter,
                ));
              },
            ),
          if (_priorityFilter != null)
            _buildActiveFilterChip(
              label: _priorityFilter == TaskPriority.high
                  ? '高優先度'
                  : _priorityFilter == TaskPriority.medium
                      ? '中優先度'
                      : '低優先度',
              onDeleted: () {
                setState(() {
                  _priorityFilter = null;
                });
                context.read<TaskBloc>().add(FilterTasksEvent(
                  statusFilter: _statusFilter,
                  priorityFilter: null,
                ));
              },
            ),
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _statusFilter = null;
                _priorityFilter = null;
              });
              context.read<TaskBloc>().add(const FilterTasksEvent());
            },
            child: const Text('クリア'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 12),
        onDeleted: onDeleted,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.all(4),
      ),
    );
  }
}