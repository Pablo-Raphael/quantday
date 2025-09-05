// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TasksController on _TasksController, Store {
  Computed<List<TaskEntity>>? _$fixedTasksComputed;

  @override
  List<TaskEntity> get fixedTasks =>
      (_$fixedTasksComputed ??= Computed<List<TaskEntity>>(
        () => super.fixedTasks,
        name: '_TasksController.fixedTasks',
      )).value;
  Computed<double>? _$fixedTasksValueComputed;

  @override
  double get fixedTasksValue => (_$fixedTasksValueComputed ??= Computed<double>(
    () => super.fixedTasksValue,
    name: '_TasksController.fixedTasksValue',
  )).value;
  Computed<double>? _$finishedTasksValueComputed;

  @override
  double get finishedTasksValue =>
      (_$finishedTasksValueComputed ??= Computed<double>(
        () => super.finishedTasksValue,
        name: '_TasksController.finishedTasksValue',
      )).value;
  Computed<double>? _$availablePointsComputed;

  @override
  double get availablePoints => (_$availablePointsComputed ??= Computed<double>(
    () => super.availablePoints,
    name: '_TasksController.availablePoints',
  )).value;
  Computed<double>? _$totalWeightOfWeightedTasksComputed;

  @override
  double get totalWeightOfWeightedTasks =>
      (_$totalWeightOfWeightedTasksComputed ??= Computed<double>(
        () => super.totalWeightOfWeightedTasks,
        name: '_TasksController.totalWeightOfWeightedTasks',
      )).value;
  Computed<double>? _$nextWeightedTaskValueComputed;

  @override
  double get nextWeightedTaskValue =>
      (_$nextWeightedTaskValueComputed ??= Computed<double>(
        () => super.nextWeightedTaskValue,
        name: '_TasksController.nextWeightedTaskValue',
      )).value;

  late final _$successMessageAtom = Atom(
    name: '_TasksController.successMessage',
    context: context,
  );

  @override
  String? get successMessage {
    _$successMessageAtom.reportRead();
    return super.successMessage;
  }

  @override
  set successMessage(String? value) {
    _$successMessageAtom.reportWrite(value, super.successMessage, () {
      super.successMessage = value;
    });
  }

  late final _$alertMessageAtom = Atom(
    name: '_TasksController.alertMessage',
    context: context,
  );

  @override
  String? get alertMessage {
    _$alertMessageAtom.reportRead();
    return super.alertMessage;
  }

  @override
  set alertMessage(String? value) {
    _$alertMessageAtom.reportWrite(value, super.alertMessage, () {
      super.alertMessage = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_TasksController.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$saveTaskAsyncAction = AsyncAction(
    '_TasksController.saveTask',
    context: context,
  );

  @override
  Future<void> saveTask({
    required String taskName,
    required double? taskPoints,
  }) {
    return _$saveTaskAsyncAction.run(
      () => super.saveTask(taskName: taskName, taskPoints: taskPoints),
    );
  }

  late final _$updateTaskAsyncAction = AsyncAction(
    '_TasksController.updateTask',
    context: context,
  );

  @override
  Future<void> updateTask(TaskEntity task) {
    return _$updateTaskAsyncAction.run(() => super.updateTask(task));
  }

  late final _$deleteTaskAsyncAction = AsyncAction(
    '_TasksController.deleteTask',
    context: context,
  );

  @override
  Future<void> deleteTask(TaskEntity task) {
    return _$deleteTaskAsyncAction.run(() => super.deleteTask(task));
  }

  late final _$toggleTaskFinishedStatusAsyncAction = AsyncAction(
    '_TasksController.toggleTaskFinishedStatus',
    context: context,
  );

  @override
  Future<void> toggleTaskFinishedStatus(TaskEntity task) {
    return _$toggleTaskFinishedStatusAsyncAction.run(
      () => super.toggleTaskFinishedStatus(task),
    );
  }

  late final _$loadTasksAsyncAction = AsyncAction(
    '_TasksController.loadTasks',
    context: context,
  );

  @override
  Future<void> loadTasks() {
    return _$loadTasksAsyncAction.run(() => super.loadTasks());
  }

  @override
  String toString() {
    return '''
successMessage: ${successMessage},
alertMessage: ${alertMessage},
errorMessage: ${errorMessage},
fixedTasks: ${fixedTasks},
fixedTasksValue: ${fixedTasksValue},
finishedTasksValue: ${finishedTasksValue},
availablePoints: ${availablePoints},
totalWeightOfWeightedTasks: ${totalWeightOfWeightedTasks},
nextWeightedTaskValue: ${nextWeightedTaskValue}
    ''';
  }
}
