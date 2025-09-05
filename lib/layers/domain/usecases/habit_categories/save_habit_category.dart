import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'package:quantday/layers/domain/repositories/habits_repository.dart';

class SaveHabitCategoryUseCase {
  final HabitsRepository _habitsRepository;

  SaveHabitCategoryUseCase(this._habitsRepository);

  Future<HabitCategoryEntity> call({required String title}) async {
    try {
      final habitCategory = HabitCategoryEntity(
        id: 0,
        title: title,
        habits: [],
      );

      final habitCategoryId = (await _habitsRepository.saveHabitCategory(
        habitCategory,
      ));

      return habitCategory.copyWith(id: habitCategoryId);
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
