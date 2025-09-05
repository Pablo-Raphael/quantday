import 'dart:core';
import 'package:mobx/mobx.dart';
import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/core/extensions/quantday_error_extension.dart';
import 'package:quantday/layers/domain/entities/habit.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/get_all_habit_categories.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/save_habit_category.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/update_habit_category.dart';
import 'package:quantday/layers/domain/usecases/habits/delete_habit.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/delete_habit_category.dart';
import 'package:quantday/layers/domain/usecases/habits/save_habit.dart';
import 'package:quantday/layers/domain/usecases/habits/update_habit.dart';
import 'package:quantday/layers/domain/usecases/tasks/save_tasks.dart';

part 'habits_controller.g.dart';

class HabitsController = _HabitsController with _$HabitsController;

abstract class _HabitsController with Store {
  late final GetAllHabitCategoriesUseCase _getAllHabitCategoriesUseCase;
  late final SaveTasksUseCase _saveTasksUseCase;
  late final UpdateHabitUseCase _updateHabitUseCase;
  late final UpdateHabitCategoryUseCase _updateHabitCategoryUseCase;
  late final DeleteHabitUseCase _deleteHabitUseCase;
  late final DeleteHabitCategoryUseCase _deleteHabitCategoryUseCase;
  late final SaveHabitCategoryUseCase _saveHabitCategoryUseCase;
  late final SaveHabitUseCase _saveHabitUseCase;

  _HabitsController({
    required GetAllHabitCategoriesUseCase getAllHabitCategoriesUseCase,
    required SaveTasksUseCase saveTasksUseCase,
    required UpdateHabitUseCase updateHabitUseCase,
    required UpdateHabitCategoryUseCase updateHabitCategoryUseCase,
    required DeleteHabitUseCase deleteHabitUseCase,
    required DeleteHabitCategoryUseCase deleteHabitCategoryUseCase,
    required SaveHabitCategoryUseCase saveHabitCategoryUseCase,
    required SaveHabitUseCase saveHabitUseCase,
  }) {
    _getAllHabitCategoriesUseCase = getAllHabitCategoriesUseCase;
    _saveTasksUseCase = saveTasksUseCase;
    _updateHabitUseCase = updateHabitUseCase;
    _updateHabitCategoryUseCase = updateHabitCategoryUseCase;
    _deleteHabitUseCase = deleteHabitUseCase;
    _deleteHabitCategoryUseCase = deleteHabitCategoryUseCase;
    _saveHabitCategoryUseCase = saveHabitCategoryUseCase;
    _saveHabitUseCase = saveHabitUseCase;
  }

  final maxAllowedHabits = 50;
  final maxAllowedHabitCategories = 50;
  final habitNameMaxLength = 70;
  final habitCategoryTitleMaxLength = 70;

  @observable
  String? successMessage;

  @observable
  String? alertMessage;

  @observable
  String? errorMessage;

  final habitCategories = ObservableList<HabitCategoryEntity>();

  final expandedCategoriesIds = ObservableList<int>();

  final addedCategoriesIds = ObservableList<int>();

  @action
  Future<void> loadHabitCategories() async {
    try {
      final habitCategories = await _getAllHabitCategoriesUseCase();
      expandedCategoriesIds.clear();
      addedCategoriesIds.clear();
      this.habitCategories.clear();
      this.habitCategories.addAll(habitCategories);
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> addHabitsToTodayTasks(HabitCategoryEntity habitCategory) async {
    if (addedCategoriesIds.contains(habitCategory.id)) {
      alertMessage = 'Essa categoria já foi adicionada';
      return;
    }

    final habits = habitCategory.habits;

    if (habits.isEmpty) {
      alertMessage = 'Essa categoria não possui hábitos';
      return;
    }

    try {
      final names = <String>[];
      final weights = <double>[];
      final points = <double?>[];
      final days = <DateTime?>[];

      for (final habit in habitCategory.habits) {
        names.add(habit.name);
        weights.add(habit.weight);
        points.add(null);
        days.add(null);
      }

      await _saveTasksUseCase(
        names: names,
        weights: weights,
        points: points,
        days: days,
      );

      addedCategoriesIds.add(habitCategory.id);
      successMessage = 'Tarefas adicionadas ao dia atual com sucesso.';
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> updateHabit(HabitEntity editedHabit) async {
    try {
      await _updateHabitUseCase(editedHabit);

      final habitCategoryIndex = habitCategories.indexWhere((habitCategory) {
        return habitCategory.id == editedHabit.habitCategoryId;
      });
      final habitCategory = habitCategories[habitCategoryIndex];

      final habitIndex = habitCategory.habits.indexWhere((habit) {
        return habit.id == editedHabit.id;
      });

      final updatedHabits = List<HabitEntity>.from(habitCategory.habits);

      updatedHabits[habitIndex] = editedHabit;

      final updatedCategory = habitCategory.copyWith(habits: updatedHabits);

      habitCategories[habitCategoryIndex] = updatedCategory;
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> deleteHabit(HabitEntity habit) async {
    try {
      await _deleteHabitUseCase(habit);

      final habitCategoryIndex = habitCategories.indexWhere((habitCategory) {
        return habitCategory.id == habit.habitCategoryId;
      });
      final habitCategory = habitCategories[habitCategoryIndex];

      final updatedHabits = List<HabitEntity>.from(habitCategory.habits);

      updatedHabits.remove(habit);

      final updatedCategory = habitCategory.copyWith(habits: updatedHabits);

      habitCategories[habitCategoryIndex] = updatedCategory;
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> deleteHabitCategory(HabitCategoryEntity habitCategory) async {
    try {
      await _deleteHabitCategoryUseCase(habitCategory);
      habitCategories.remove(habitCategory);
      expandedCategoriesIds.remove(habitCategory.id);
      addedCategoriesIds.remove(habitCategory.id);
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> updateHabitCategory(
    HabitCategoryEntity editedHabitCategory,
  ) async {
    try {
      await _updateHabitCategoryUseCase(editedHabitCategory);

      final habitCategoryIndex = habitCategories.indexWhere((habitCategory) {
        return habitCategory.id == editedHabitCategory.id;
      });

      habitCategories[habitCategoryIndex] = editedHabitCategory;
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> saveHabitCategory({required String title}) async {
    try {
      habitCategories.add(await _saveHabitCategoryUseCase(title: title));
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (_) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  @action
  Future<void> saveHabit({
    required String name,
    required HabitCategoryEntity habitCategory,
    double? weight,
  }) async {
    try {
      final habit = await _saveHabitUseCase(
        name: name,
        habitCategoryId: habitCategory.id,
        weight: weight,
      );

      final habitCategoryIndex = habitCategories.indexOf(habitCategory);

      final updatedHabits = List<HabitEntity>.from(habitCategory.habits);

      updatedHabits.add(habit);

      final updatedCategory = habitCategory.copyWith(habits: updatedHabits);

      habitCategories[habitCategoryIndex] = updatedCategory;
    } on QuantDayException catch (error) {
      errorMessage = error.cause.text;
    } catch (e) {
      errorMessage = QuantDayError.unknown.text;
    }
  }

  double getIncrementedHabitWeight(double currentWeight) {
    double newWeight;

    if (currentWeight + 0.5 <= 5) {
      newWeight = currentWeight + 0.5;
    } else {
      newWeight = 1;
    }

    return newWeight;
  }
}
