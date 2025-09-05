import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/presentation/adapters/edit_dialog/task_edit_dialog_adapter.dart';
import 'package:quantday/layers/presentation/widgets/edit_dialog.dart';

class TaskWidget extends StatefulWidget {
  final TaskEntity task;
  final Function(TaskEntity) updateTask;
  final Function(TaskEntity) deleteTask;
  final Function(TaskEntity) toggleStatus;
  final double taskValue;
  final double availablePoints;
  final int taskNameMaxLength;
  final bool canSetPoints;
  final bool canDeleteTask;
  final Function(String) setAlert;

  const TaskWidget({
    super.key,
    required this.task,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleStatus,
    required this.taskValue,
    required this.availablePoints,
    required this.taskNameMaxLength,
    required this.canSetPoints,
    required this.canDeleteTask,
    required this.setAlert,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  void _securelyDeleteTask(BuildContext context) async {
    if (!widget.canDeleteTask) {
      widget.setAlert('Essa tarefa não pode ser apagada...');
      return;
    }

    const snackBarDuration = Duration(seconds: 3);

    final deleteTimer = Timer(
      snackBarDuration,
      () => widget.deleteTask(widget.task),
    );

    final snack = SnackBar(
      duration: snackBarDuration,
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      content: Container(
        alignment: Alignment.centerLeft,
        height: 45,
        child: const Text(
          'Apagando tarefa...',
          style: TextStyle(color: Colors.white),
        ),
      ),
      action: SnackBarAction(
        label: 'Cancelar',
        textColor: Colors.red.shade900,
        onPressed: () {
          setState(() {
            deleteTimer.cancel();
          });
        },
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _openEditDialog(BuildContext context) {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (_) {
        return EditDialog<TaskEditDialogAdapter>(
          item: TaskEditDialogAdapter(widget.task),
          availablePoints: widget.availablePoints,
          nameMaxLength: widget.taskNameMaxLength,
          canSetPoints: widget.canSetPoints,
          onSave: (TaskEditDialogAdapter edited) {
            widget.updateTask(edited.toEntity());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (_) => _securelyDeleteTask(context),
      background: Container(
        color: Colors.red.shade900,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            GestureDetector(
              onTap: () => _openEditDialog(context),
              child: CircularPercentIndicator(
                radius: 17.5,
                lineWidth: 1.5,
                percent: (widget.taskValue / 10).clamp(0.0, 1.0),
                progressColor: widget.task.isFixed ? Colors.cyan : Colors.grey,
                backgroundColor: Colors.white12,
                center: Text(
                  widget.taskValue.toStringAsFixed(2).substring(0, 4),
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: () => _openEditDialog(context),
                child: Text(
                  widget.task.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration:
                        widget.task.isFinished
                            ? TextDecoration.lineThrough
                            : null,
                    decorationColor: Colors.grey,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () => widget.toggleStatus(widget.task),
              child: SizedBox(
                height: 20,
                width: 20,
                child:
                    widget.task.isFinished
                        ? Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.cyan,
                          ),
                          child: const Icon(Icons.check, size: 16),
                        )
                        : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
