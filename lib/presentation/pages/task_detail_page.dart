import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final bool isNewTask;

  const TaskDetailPage({
    Key? key,
    required this.task,
    this.isNewTask = false,
  }) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late TaskPriority _priority;
  late TaskStatus _status;
  bool _isFormDirty = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
    _status = widget.task.status;

    // Listen for changes to determine if form is dirty
    _titleController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    final titleChanged = _titleController.text != widget.task.title;
    final descriptionChanged = _descriptionController.text != widget.task.description;
    final dueDateChanged = _dueDate != widget.task.dueDate;
    final priorityChanged = _priority != widget.task.priority;
    final statusChanged = _status != widget.task.status;

    final isDirty = titleChanged || descriptionChanged || dueDateChanged || 
                   priorityChanged || statusChanged;
    
    if (isDirty != _isFormDirty) {
      setState(() {
        _isFormDirty = isDirty;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewTask ? '新しいタスク' : 'タスク詳細'),
        actions: [
          if (!widget.isNewTask)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'タイトルを入力してください';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '詳細',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 500,
            ),
            
            const SizedBox(height: 16),
            
            // Due date picker
            ListTile(
              title: const Text('期限'),
              subtitle: Text(DateFormat('yyyy/MM/dd').format(_dueDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDueDate,
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Priority selector
            ListTile(
              title: const Text('優先度'),
              subtitle: _buildPriorityWidget(_priority),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _selectPriority,
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Status selector
            ListTile(
              title: const Text('ステータス'),
              subtitle: _buildStatusWidget(_status),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _selectStatus,
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            
            if (!widget.isNewTask) ...[
              const SizedBox(height: 24),
              
              // Created date info
              ListTile(
                title: const Text('作成日'),
                subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(widget.task.createdAt)),
                tileColor: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              
              // Last updated info, if available
              if (widget.task.updatedAt != null) ...[
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('最終更新'),
                  subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(widget.task.updatedAt!)),
                  tileColor: Colors.grey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('キャンセル'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isFormDirty ? _saveTask : null,
                child: Text(widget.isNewTask ? '作成' : '保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: '期限を選択',
      cancelText: 'キャンセル',
      confirmText: '確定',
    );

    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
        _onFormChanged();
      });
    }
  }

  void _selectPriority() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('優先度を選択'),
          children: [
            for (var priority in TaskPriority.values)
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _priority = priority;
                    _onFormChanged();
                  });
                  Navigator.pop(context);
                },
                child: _buildPriorityWidget(priority),
              ),
          ],
        );
      },
    );
  }

  void _selectStatus() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('ステータスを選択'),
          children: [
            for (var status in TaskStatus.values)
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _status = status;
                    _onFormChanged();
                  });
                  Navigator.pop(context);
                },
                child: _buildStatusWidget(status),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPriorityWidget(TaskPriority priority) {
    late final Color color;
    late final String text;
    
    switch (priority) {
      case TaskPriority.high:
        color = Colors.red[100]!;
        text = '高優先度';
        break;
      case TaskPriority.medium:
        color = Colors.orange[100]!;
        text = '中優先度';
        break;
      case TaskPriority.low:
        color = Colors.green[100]!;
        text = '低優先度';
        break;
    }
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color.withBlue(0).withRed(0).withGreen(0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusWidget(TaskStatus status) {
    late final Color color;
    late final String text;
    
    switch (status) {
      case TaskStatus.todo:
        color = Colors.grey[300]!;
        text = '未着手';
        break;
      case TaskStatus.inProgress:
        color = Colors.blue[100]!;
        text = '進行中';
        break;
      case TaskStatus.completed:
        color = Colors.green[100]!;
        text = '完了';
        break;
    }
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color.withBlue(0).withRed(0).withGreen(0),
            ),
          ),
        ),
      ],
    );
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      priority: _priority,
      status: _status,
      updatedAt: DateTime.now(),
    );

    if (widget.isNewTask) {
      context.read<TaskBloc>().add(AddTaskEvent(updatedTask));
    } else {
      context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
    }

    Navigator.pop(context, true);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: const Text('このタスクを削除してもよろしいですか？この操作は元に戻せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskBloc>().add(DeleteTaskEvent(widget.task.id));
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}