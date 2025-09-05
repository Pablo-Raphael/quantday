import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/layers/presentation/controllers/calendar_controller.dart';
import 'package:quantday/layers/presentation/pages/calendar/widgets/task_calendar.dart';
import 'package:quantday/layers/presentation/utils/show_quantday_snack_bar.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_task_bar.dart';
import 'package:quantday/layers/presentation/widgets/task.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  final _controller = GetIt.I<CalendarController>();
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

  void _loadData() => _controller.loadAllTasks();

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
        if (_controller.isLoadingAllTasks) {
          return Center(child: CircularProgressIndicator(color: Colors.cyan));
        }

        final tasks = _controller.tasksOfSelectedDay;
        final availablePoints = _controller.getAvailablePoints(tasks);
        final totalWeight = _controller.getTotalWeightOfWeightedTasks(tasks);
        final today = DateTime.now().dateOnly;
        final isFutureSelectedDay = _controller.selectedDay.isAfter(today);
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TaskCalendar(),

                  const Divider(color: Colors.grey),

                  Column(
                    children:
                        tasks.map((task) {
                          return TaskWidget(
                            task: task,
                            updateTask: _controller.updateSelectedDayTask,
                            deleteTask: _controller.deleteSelectedDayTask,
                            toggleStatus: (_) {},
                            availablePoints: availablePoints,
                            taskNameMaxLength: _controller.taskNameMaxLength,
                            canSetPoints: false,
                            canDeleteTask: isFutureSelectedDay,
                            taskValue: _controller.getTaskValue(
                              task: task,
                              availablePoints: availablePoints,
                              totalWeightOfWeightedTasks: totalWeight,
                            ),
                            setAlert: (alert) {
                              _controller.alertMessage = alert;
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

            if (isFutureSelectedDay)
              AddTaskBar(
                maxTaskCount: _controller.maxAllowedTasks,
                taskNameMaxLength: _controller.taskNameMaxLength,
                currentTaskCount: tasks.length,
                availablePoints: availablePoints,
                canAddFixedTasks: false,
                saveTask: ({required taskName, required taskPoints}) {
                  _controller.saveTaskOnSelectedDay(taskName: taskName);
                },
                nextWeightedTaskValue: _controller.getNextWeightedTaskValue(
                  availablePoints: availablePoints,
                  totalWeightOfWeightedTasks: totalWeight,
                ),
              ),
          ],
        );
      },
    );
  }
}
