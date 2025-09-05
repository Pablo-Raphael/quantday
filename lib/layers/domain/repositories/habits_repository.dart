import 'package:quantday/layers/domain/entities/habit.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';

abstract class HabitsRepository {
  Future<int> saveHabitCategory(HabitCategoryEntity habitCategory);

  Future<List<HabitCategoryEntity>> getAllHabitCategories();

  Future<void> updateHabitCategory(HabitCategoryEntity habitCategory);

  Future<void> deleteHabitCategory(int habitCategoryId);

  Future<int> saveHabit(HabitEntity habit);

  Future<void> updateHabit(HabitEntity habit);

  Future<void> deleteHabit(int habitId);
}
