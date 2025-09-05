import 'dart:core';
import 'package:mobx/mobx.dart';
import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/core/extensions/quantday_error_extension.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/domain/usecases/tasks/save_task.dart';
import 'package:quantday/layers/domain/usecases/tasks/delete_task.dart';
import 'package:quantday/layers/domain/usecases/tasks/get_current_day_tasks.dart';
import 'package:quantday/layers/domain/usecases/tasks/toggle_task_finished_status.dart';
import 'package:quantday/layers/domain/usecases/tasks/update_task.dart';

part 'tasks_controller.g.dart';

class TasksController = _TasksController with _$TasksController;

abstract class _TasksController with Store {
  late final SaveTaskUseCase _saveTaskUseCase;
  late final UpdateTaskUseCase _updateTaskUseCase;
  late final GetCurrentDayTasksUseCase _getCurrentDayTasksUseCase;
  late final DeleteTaskUseCase _deleteTaskUseCase;
  late final ToggleTaskFinishedStatusUseCase _toggleTaskFinishedStatusUseCase;

  _TasksController({
    required SaveTaskUseCase saveTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required GetCurrentDayTasksUseCase getCurrentDayTasksUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required ToggleTaskFinishedStatusUseCase toggleTaskFinishedStatusUseCase,
  }) {
    _saveTaskUseCase = saveTaskUseCase;
    _updateTaskUseCase = updateTaskUseCase;
    _getCurrentDayTasksUseCase = getCurrentDayTasksUseCase;
    _deleteTaskUseCase = deleteTaskUseCase;
    _toggleTaskFinishedStatusUseCase = toggleTaskFinishedStatusUseCase;
  }

  final maxAllowedTasks = 50;
  final taskNameMaxLength = 70;

  final ObservableList<TaskEntity> tasks = ObservableList<TaskEntity>();

  @observable
  String? successMessage;

  @observable
  String? alertMessage;

  @observable
  String? errorMessage;

  @computed
  List<TaskEntity> get fixedTasks {
    return tasks.where((TaskEntity task) => task.isFixed).toList();
  }

  @computed
  double get fixedTasksValue {
    return fixedTasks
        .map((task) => task.points)
        .fold(0, (sum, points) => sum += points);
  }

  @computed
  double get finishedTasksValue {
    double points = 0.0;

    for (final task in tasks) {
      if (task.isFinished) {
        points += getTaskValue(task);
      }
    }

    return points;
  }

  @computed
  double get availablePoints {
    return 10 - fixedTasksValue;
  }

  @computed
  double get totalWeightOfWeightedTasks {
    double weight = 0;

    for (final task in tasks) {
      if (task.isWeighted) {
        weight += task.weight;
      }
    }

    return weight;
  }

  @computed
  double get nextWeightedTaskValue {
    return availablePoints / (totalWeightOfWeightedTasks + 1);
  }

  double getTaskValue(TaskEntity task) {
    if (task.isFixed) {
      return task.points;
    } else {
      return availablePoints / totalWeightOfWeightedTasks * task.weight;
    }
  }

  @action
  Future<void> saveTask({
    required String taskName,
    required double? taskPoints,
  }) async {
    try {
      tasks.add(await _saveTaskUseCase(name: taskName, points: taskPoints));
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> updateTask(TaskEntity task) async {
    try {
      await _updateTaskUseCase(task);

      final index = tasks.indexWhere((t) => t.id == task.id);
      tasks[index] = task;
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> deleteTask(TaskEntity task) async {
    try {
      await _deleteTaskUseCase(task.id);
      tasks.remove(task);
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> toggleTaskFinishedStatus(TaskEntity task) async {
    try {
      await _toggleTaskFinishedStatusUseCase(task);

      tasks.remove(task);

      if (task.isFinished) {
        tasks.insert(0, task.copyWith(isFinished: false));
      } else {
        tasks.add(task.copyWith(isFinished: true));
      }
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> loadTasks() async {
    try {
      final List<TaskEntity> tasks = await _getCurrentDayTasksUseCase();
      this.tasks.clear();
      this.tasks.addAll(tasks);
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }
}
