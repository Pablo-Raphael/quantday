import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:quantday/layers/presentation/controllers/tasks_controller.dart';
import 'package:quantday/layers/presentation/widgets/current_day_score.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_task_bar.dart';
import 'package:quantday/layers/presentation/utils/show_quantday_snack_bar.dart';
import 'package:quantday/layers/presentation/widgets/task.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  final _controller = GetIt.I<TasksController>();
  late final ReactionDisposer _successReactionDisposer;
  late final ReactionDisposer _alertReactionDisposer;
  late final ReactionDisposer _errorReactionDisposer;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _successReactionDisposer = reaction((_) => _controller.successMessage, (
      successMessage,
    ) {
      if (successMessage != null && context.mounted) {
        showQuantDaySnackBar(
          context,
          type: QuantDaySnackBarType.success,
          title: 'Sucesso:',
          message: successMessage,
        );
        _controller.successMessage = null;
      }
    });
    _alertReactionDisposer = reaction((_) => _controller.alertMessage, (
      alertMessage,
    ) {
      if (alertMessage != null && context.mounted) {
        showQuantDaySnackBar(
          context,
          type: QuantDaySnackBarType.alert,
          title: 'Aviso:',
          message: alertMessage,
        );
        _controller.alertMessage = null;
        setState(() {});
      }
    });
    _errorReactionDisposer = reaction((_) => _controller.errorMessage, (
      errorMessage,
    ) {
      if (errorMessage != null && context.mounted) {
        showQuantDaySnackBar(
          context,
          type: QuantDaySnackBarType.error,
          title: 'Erro:',
          message: errorMessage,
        );
        _controller.errorMessage = null;
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = DefaultTabController.of(context);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _successReactionDisposer();
    _alertReactionDisposer();
    _errorReactionDisposer();
    _tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _loadData() => _controller.loadTasks();

  void _handleTabChange() {
    final isSameIndex = _tabController.index == widget.tabIndex;
    if (isSameIndex && _tabController.indexIsChanging) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          children: [
            CurrentDayScore(progress: _controller.finishedTasksValue),

            Expanded(
              child: ListView.builder(
                itemCount: _controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = _controller.tasks[index];
                  return TaskWidget(
                    task: task,
                    taskValue: _controller.getTaskValue(task),
                    updateTask: _controller.updateTask,
                    deleteTask: _controller.deleteTask,
                    toggleStatus: _controller.toggleTaskFinishedStatus,
                    availablePoints: _controller.availablePoints,
                    taskNameMaxLength: _controller.taskNameMaxLength,
                    canSetPoints: true,
                    canDeleteTask: true,
                    setAlert: (alert) => _controller.alertMessage = alert,
                  );
                },
              ),
            ),

            AddTaskBar(
              saveTask: _controller.saveTask,
              maxTaskCount: _controller.maxAllowedTasks,
              currentTaskCount: _controller.tasks.length,
              availablePoints: _controller.availablePoints,
              nextWeightedTaskValue: _controller.nextWeightedTaskValue,
              taskNameMaxLength: _controller.taskNameMaxLength,
              canAddFixedTasks: true,
            ),
          ],
        );
      },
    );
  }
}
