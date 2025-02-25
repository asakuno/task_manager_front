import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool?) onStatusChanged;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = task.dueDate.isBefore(DateTime.now()) && 
                          task.status != TaskStatus.completed;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Checkbox for task status
              Checkbox(
                value: task.status == TaskStatus.completed,
                onChanged: onStatusChanged,
              ),
              
              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with decoration if completed
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Description - only show first line
                    Text(
                      task.description.split('\n').first,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Bottom row with due date and priority
                    Row(
                      children: [
                        // Due date
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: isOverdue ? Colors.red : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('yyyy/MM/dd').format(task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : Colors.grey[600],
                            fontWeight: isOverdue ? FontWeight.bold : null,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Priority indicator
                        _buildPriorityBadge(task.priority),
                        
                        const SizedBox(width: 8),
                        
                        // Status badge
                        _buildStatusBadge(task.status),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Right arrow
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    late final Color color;
    late final String text;
    
    switch (priority) {
      case TaskPriority.high:
        color = Colors.red[100]!;
        text = '高';
        break;
      case TaskPriority.medium:
        color = Colors.orange[100]!;
        text = '中';
        break;
      case TaskPriority.low:
        color = Colors.green[100]!;
        text = '低';
        break;
    }
    
    return Container(
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
    );
  }

  Widget _buildStatusBadge(TaskStatus status) {
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
    
    return Container(
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
    );
  }
}