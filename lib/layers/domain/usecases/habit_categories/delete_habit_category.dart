import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'package:quantday/layers/domain/repositories/habits_repository.dart';

class DeleteHabitCategoryUseCase {
  final HabitsRepository _habitsRepository;

  DeleteHabitCategoryUseCase(this._habitsRepository);

  Future<void> call(HabitCategoryEntity habitCategory) async {
    try {
      await _habitsRepository.deleteHabitCategory(habitCategory.id);
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
