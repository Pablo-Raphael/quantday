import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/habit.dart';
import 'package:quantday/layers/domain/repositories/habits_repository.dart';

class DeleteHabitUseCase {
  final HabitsRepository _habitsRepository;

  DeleteHabitUseCase(this._habitsRepository);

  Future<void> call(HabitEntity habit) async {
    try {
      await _habitsRepository.deleteHabit(habit.id);
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
