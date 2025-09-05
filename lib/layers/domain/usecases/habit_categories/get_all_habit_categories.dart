import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'package:quantday/layers/domain/repositories/habits_repository.dart';

class GetAllHabitCategoriesUseCase {
  final HabitsRepository _habitsRepository;

  GetAllHabitCategoriesUseCase(this._habitsRepository);

  Future<List<HabitCategoryEntity>> call() async {
    try {
      return await _habitsRepository.getAllHabitCategories();
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
