import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/habit.dart';
import 'package:quantday/layers/domain/repositories/habits_repository.dart';

class SaveHabitUseCase {
  final HabitsRepository _habitsRepository;

  SaveHabitUseCase(this._habitsRepository);

  Future<HabitEntity> call({
    required String name,
    required int habitCategoryId,
    double? weight,
  }) async {
    try {
      final habit = HabitEntity(
        id: 0,
        habitCategoryId: habitCategoryId,
        name: name,
        weight: weight?.clamp(1, 5) ?? 1,
      );

      final habitId = (await _habitsRepository.saveHabit(habit));

      return habit.copyWith(id: habitId);
    } on QuantDayException {
      rethrow;
    } catch (e) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
