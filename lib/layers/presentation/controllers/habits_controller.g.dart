// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HabitsController on _HabitsController, Store {
  late final _$successMessageAtom = Atom(
    name: '_HabitsController.successMessage',
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
    name: '_HabitsController.alertMessage',
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
    name: '_HabitsController.errorMessage',
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

  late final _$loadHabitCategoriesAsyncAction = AsyncAction(
    '_HabitsController.loadHabitCategories',
    context: context,
  );

  @override
  Future<void> loadHabitCategories() {
    return _$loadHabitCategoriesAsyncAction.run(
      () => super.loadHabitCategories(),
    );
  }

  late final _$addHabitsToTodayTasksAsyncAction = AsyncAction(
    '_HabitsController.addHabitsToTodayTasks',
    context: context,
  );

  @override
  Future<void> addHabitsToTodayTasks(HabitCategoryEntity habitCategory) {
    return _$addHabitsToTodayTasksAsyncAction.run(
      () => super.addHabitsToTodayTasks(habitCategory),
    );
  }

  late final _$updateHabitAsyncAction = AsyncAction(
    '_HabitsController.updateHabit',
    context: context,
  );

  @override
  Future<void> updateHabit(HabitEntity editedHabit) {
    return _$updateHabitAsyncAction.run(() => super.updateHabit(editedHabit));
  }

  late final _$deleteHabitAsyncAction = AsyncAction(
    '_HabitsController.deleteHabit',
    context: context,
  );

  @override
  Future<void> deleteHabit(HabitEntity habit) {
    return _$deleteHabitAsyncAction.run(() => super.deleteHabit(habit));
  }

  late final _$deleteHabitCategoryAsyncAction = AsyncAction(
    '_HabitsController.deleteHabitCategory',
    context: context,
  );

  @override
  Future<void> deleteHabitCategory(HabitCategoryEntity habitCategory) {
    return _$deleteHabitCategoryAsyncAction.run(
      () => super.deleteHabitCategory(habitCategory),
    );
  }

  late final _$updateHabitCategoryAsyncAction = AsyncAction(
    '_HabitsController.updateHabitCategory',
    context: context,
  );

  @override
  Future<void> updateHabitCategory(HabitCategoryEntity editedHabitCategory) {
    return _$updateHabitCategoryAsyncAction.run(
      () => super.updateHabitCategory(editedHabitCategory),
    );
  }

  late final _$saveHabitCategoryAsyncAction = AsyncAction(
    '_HabitsController.saveHabitCategory',
    context: context,
  );

  @override
  Future<void> saveHabitCategory({required String title}) {
    return _$saveHabitCategoryAsyncAction.run(
      () => super.saveHabitCategory(title: title),
    );
  }

  late final _$saveHabitAsyncAction = AsyncAction(
    '_HabitsController.saveHabit',
    context: context,
  );

  @override
  Future<void> saveHabit({
    required String name,
    required HabitCategoryEntity habitCategory,
    double? weight,
  }) {
    return _$saveHabitAsyncAction.run(
      () => super.saveHabit(
        name: name,
        habitCategory: habitCategory,
        weight: weight,
      ),
    );
  }

  @override
  String toString() {
    return '''
successMessage: ${successMessage},
alertMessage: ${alertMessage},
errorMessage: ${errorMessage}
    ''';
  }
}
