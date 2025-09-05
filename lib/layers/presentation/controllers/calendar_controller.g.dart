// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CalendarController on _CalendarController, Store {
  Computed<List<TaskEntity>>? _$tasksOfSelectedDayComputed;

  @override
  List<TaskEntity> get tasksOfSelectedDay =>
      (_$tasksOfSelectedDayComputed ??= Computed<List<TaskEntity>>(
        () => super.tasksOfSelectedDay,
        name: '_CalendarController.tasksOfSelectedDay',
      )).value;

  late final _$isLoadingAllTasksAtom = Atom(
    name: '_CalendarController.isLoadingAllTasks',
    context: context,
  );

  @override
  bool get isLoadingAllTasks {
    _$isLoadingAllTasksAtom.reportRead();
    return super.isLoadingAllTasks;
  }

  @override
  set isLoadingAllTasks(bool value) {
    _$isLoadingAllTasksAtom.reportWrite(value, super.isLoadingAllTasks, () {
      super.isLoadingAllTasks = value;
    });
  }

  late final _$successMessageAtom = Atom(
    name: '_CalendarController.successMessage',
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
    name: '_CalendarController.alertMessage',
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
    name: '_CalendarController.errorMessage',
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

  late final _$selectedDayAtom = Atom(
    name: '_CalendarController.selectedDay',
    context: context,
  );

  @override
  DateTime get selectedDay {
    _$selectedDayAtom.reportRead();
    return super.selectedDay;
  }

  @override
  set selectedDay(DateTime value) {
    _$selectedDayAtom.reportWrite(value, super.selectedDay, () {
      super.selectedDay = value;
    });
  }

  late final _$focusedDayAtom = Atom(
    name: '_CalendarController.focusedDay',
    context: context,
  );

  @override
  DateTime get focusedDay {
    _$focusedDayAtom.reportRead();
    return super.focusedDay;
  }

  @override
  set focusedDay(DateTime value) {
    _$focusedDayAtom.reportWrite(value, super.focusedDay, () {
      super.focusedDay = value;
    });
  }

  late final _$firstDayAtom = Atom(
    name: '_CalendarController.firstDay',
    context: context,
  );

  @override
  DateTime? get firstDay {
    _$firstDayAtom.reportRead();
    return super.firstDay;
  }

  @override
  set firstDay(DateTime? value) {
    _$firstDayAtom.reportWrite(value, super.firstDay, () {
      super.firstDay = value;
    });
  }

  late final _$loadAllTasksAsyncAction = AsyncAction(
    '_CalendarController.loadAllTasks',
    context: context,
  );

  @override
  Future<void> loadAllTasks() {
    return _$loadAllTasksAsyncAction.run(() => super.loadAllTasks());
  }

  late final _$saveTaskOnSelectedDayAsyncAction = AsyncAction(
    '_CalendarController.saveTaskOnSelectedDay',
    context: context,
  );

  @override
  Future<void> saveTaskOnSelectedDay({required String taskName}) {
    return _$saveTaskOnSelectedDayAsyncAction.run(
      () => super.saveTaskOnSelectedDay(taskName: taskName),
    );
  }

  late final _$updateSelectedDayTaskAsyncAction = AsyncAction(
    '_CalendarController.updateSelectedDayTask',
    context: context,
  );

  @override
  Future<void> updateSelectedDayTask(TaskEntity editedTask) {
    return _$updateSelectedDayTaskAsyncAction.run(
      () => super.updateSelectedDayTask(editedTask),
    );
  }

  late final _$deleteSelectedDayTaskAsyncAction = AsyncAction(
    '_CalendarController.deleteSelectedDayTask',
    context: context,
  );

  @override
  Future<void> deleteSelectedDayTask(TaskEntity task) {
    return _$deleteSelectedDayTaskAsyncAction.run(
      () => super.deleteSelectedDayTask(task),
    );
  }

  @override
  String toString() {
    return '''
isLoadingAllTasks: ${isLoadingAllTasks},
successMessage: ${successMessage},
alertMessage: ${alertMessage},
errorMessage: ${errorMessage},
selectedDay: ${selectedDay},
focusedDay: ${focusedDay},
firstDay: ${firstDay},
tasksOfSelectedDay: ${tasksOfSelectedDay}
    ''';
  }
}
