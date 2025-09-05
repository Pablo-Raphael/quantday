import 'package:mobx/mobx.dart';
import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/core/extensions/quantday_error_extension.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/domain/usecases/tasks/save_task.dart';
import 'package:quantday/layers/domain/usecases/tasks/delete_task.dart';
import 'package:quantday/layers/domain/usecases/tasks/get_all_tasks_grouped_by_day.dart';
import 'package:quantday/layers/domain/usecases/tasks/update_task.dart';

part 'calendar_controller.g.dart';

class CalendarController = _CalendarController with _$CalendarController;

abstract class _CalendarController with Store {
  late final GetAllTasksGroupedByDayUseCase _getAllTasksGroupedByDayUseCase;
  late final SaveTaskUseCase _saveTaskUseCase;
  late final UpdateTaskUseCase _updateTaskUseCase;
  late final DeleteTaskUseCase _deleteTaskUseCase;

  _CalendarController({
    required GetAllTasksGroupedByDayUseCase getAllTasksGroupedByDayUseCase,
    required SaveTaskUseCase saveTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  }) {
    _getAllTasksGroupedByDayUseCase = getAllTasksGroupedByDayUseCase;
    _saveTaskUseCase = saveTaskUseCase;
    _updateTaskUseCase = updateTaskUseCase;
    _deleteTaskUseCase = deleteTaskUseCase;

    final today = DateTime.now();
    standardMinDate = DateTime(today.year, today.month - 3, today.day);
    lastDate = DateTime(today.year + 1, today.month, today.day);
  }

  late final DateTime standardMinDate;
  late final DateTime lastDate;
  final maxAllowedTasks = 50;
  final taskNameMaxLength = 70;

  @observable
  bool isLoadingAllTasks = false;

  @observable
  String? successMessage;

  @observable
  String? alertMessage;

  @observable
  String? errorMessage;

  @observable
  DateTime selectedDay = DateTime.now().dateOnly;

  @observable
  DateTime focusedDay = DateTime.now().dateOnly;

  @observable
  DateTime? firstDay;

  final allTasks = ObservableMap<DateTime, ObservableList<TaskEntity>>();

  @computed
  List<TaskEntity> get tasksOfSelectedDay {
    try {
      return allTasks[selectedDay.dateOnly] ??= ObservableList();
    } catch (_) {
      return ObservableList();
    }
  }

  @action
  Future<void> loadAllTasks() async {
    try {
      isLoadingAllTasks = true;

      final tasks = await _getAllTasksGroupedByDayUseCase();

      final observableTasks = tasks.map((date, list) {
        return MapEntry(date, ObservableList.of(list));
      });

      allTasks.clear();
      allTasks.addAll(observableTasks);

      firstDay ??= tasks.keys.lastOrNull;
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    } finally {
      isLoadingAllTasks = false;
    }
  }

  @action
  Future<void> saveTaskOnSelectedDay({required String taskName}) async {
    try {
      tasksOfSelectedDay.add(
        await _saveTaskUseCase(name: taskName, day: selectedDay),
      );
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> updateSelectedDayTask(TaskEntity editedTask) async {
    try {
      final index = tasksOfSelectedDay.indexWhere((t) => t.id == editedTask.id);

      if (index == -1) throw QuantDayException(QuantDayError.unknown);

      await _updateTaskUseCase(editedTask);

      tasksOfSelectedDay[index] = editedTask;
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> deleteSelectedDayTask(TaskEntity task) async {
    try {
      await _deleteTaskUseCase(task.id);
      tasksOfSelectedDay.remove(task);
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  List<TaskEntity> getTasksOfSpecificDay(DateTime day) {
    return allTasks[day.dateOnly] ??= ObservableList();
  }

  double getFinishedTasksValue(List<TaskEntity> tasks) {
    final availablePoints = getAvailablePoints(tasks);
    final totalWeightOfWeightedTasks = getTotalWeightOfWeightedTasks(tasks);

    double points = 0.0;

    for (final task in tasks) {
      if (task.isFinished) {
        points += getTaskValue(
          task: task,
          availablePoints: availablePoints,
          totalWeightOfWeightedTasks: totalWeightOfWeightedTasks,
        );
      }
    }

    return points;
  }

  double getTaskValue({
    required TaskEntity task,
    required double availablePoints,
    required double totalWeightOfWeightedTasks,
  }) {
    if (task.isFixed) return task.points;
    return (totalWeightOfWeightedTasks > 0)
        ? (availablePoints / totalWeightOfWeightedTasks) * task.weight
        : 0.0;
  }

  double getAvailablePoints(List<TaskEntity> tasks) {
    return 10 - getFixedTasksValue(tasks);
  }

  double getFixedTasksValue(List<TaskEntity> tasks) {
    double total = 0.0;

    for (final task in tasks) {
      if (task.isFixed) {
        total += task.points;
      }
    }

    return total;
  }

  double getTotalWeightOfWeightedTasks(List<TaskEntity> tasks) {
    double weight = 0.0;

    for (final task in tasks) {
      if (task.isWeighted) {
        weight += task.weight;
      }
    }

    return weight;
  }

  double getNextWeightedTaskValue({
    required double availablePoints,
    required double totalWeightOfWeightedTasks,
  }) {
    return availablePoints / (totalWeightOfWeightedTasks + 1);
  }
}
