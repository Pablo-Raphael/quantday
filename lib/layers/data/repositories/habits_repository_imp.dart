import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/data/DTOs/habit_category_dto.dart';
import 'package:quantday/layers/data/DTOs/habit_dto.dart';
import 'package:quantday/layers/data/datasources/habit_categories_datasource.dart';
import 'package:quantday/layers/data/datasources/habits_datasource.dart';
import 'package:quantday/layers/domain/entities/habit.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'package:quantday/layers/domain/repositories/habits_repository.dart';

class HabitsRepositoryImp implements HabitsRepository {
  final HabitCategoriesDataSource _habitCategoriesDataSource;
  final HabitsDataSource _habitsDataSource;

  HabitsRepositoryImp(this._habitCategoriesDataSource, this._habitsDataSource);

  @override
  Future<int> saveHabitCategory(HabitCategoryEntity habitCategory) async {
    return await _habitCategoriesDataSource.createHabitCategory(
      HabitCategoryDTO.fromEntity(habitCategory),
    );
  }

  @override
  Future<List<HabitCategoryEntity>> getAllHabitCategories() async {
    final categoriesFuture = _habitCategoriesDataSource.getHabitCategories();
    final habitsFuture = _habitsDataSource.getHabits();

    final categoriesDto = await categoriesFuture;
    final habitsDto = await habitsFuture;

    final Map<int, List<HabitEntity>> habitsByCategory = {};
    for (final habit in habitsDto) {
      final entity = habit.toEntity();
      habitsByCategory.putIfAbsent(habit.habitCategoryId, () => []).add(entity);
    }

    return categoriesDto.map((categoryDto) {
      final categoryEntity = categoryDto.toEntity();
      final habits = habitsByCategory[categoryDto.id] ?? [];
      return categoryEntity.copyWith(habits: habits);
    }).toList();
  }

  @override
  Future<void> updateHabitCategory(HabitCategoryEntity habitCategory) async {
    final affectedRows = await _habitCategoriesDataSource.updateCategory(
      HabitCategoryDTO.fromEntity(habitCategory),
    );

    if (affectedRows != 1) {
      throw QuantDayException(QuantDayError.moreThanOneRowAffectedInDataBase);
    }
  }

  @override
  Future<void> deleteHabitCategory(int habitCategoryId) async {
    final affectedRows = await _habitCategoriesDataSource.deleteHabitCategory(
      habitCategoryId,
    );

    if (affectedRows != 1) {
      throw QuantDayException(QuantDayError.moreThanOneRowAffectedInDataBase);
    }
  }

  @override
  Future<int> saveHabit(HabitEntity habit) async {
    return await _habitsDataSource.createHabit(HabitDTO.fromEntity(habit));
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    final affectedRows = await _habitsDataSource.updateHabit(
      HabitDTO.fromEntity(habit),
    );

    if (affectedRows != 1) {
      throw QuantDayException(QuantDayError.moreThanOneRowAffectedInDataBase);
    }
  }

  @override
  Future<void> deleteHabit(int habitId) async {
    final affectedRows = await _habitsDataSource.deleteHabit(habitId);

    if (affectedRows != 1) {
      throw QuantDayException(QuantDayError.moreThanOneRowAffectedInDataBase);
    }
  }
}
