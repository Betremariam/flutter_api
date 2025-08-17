import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (val) {
            task.completed = val!;
            taskProvider.updateTask(task, authProvider.user!.token);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            taskProvider.deleteTask(task.id, authProvider.user!.token);
          },
        ),
      ),
    );
  }
}
