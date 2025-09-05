import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class SaveTasksUseCase {
  final TasksRepository _tasksRepository;

  SaveTasksUseCase(this._tasksRepository);

  Future<List<TaskEntity>> call({
    required List<String> names,
    required List<double?> points,
    required List<double?> weights,
    required List<DateTime?> days,
  }) async {
    try {
      if (names.isEmpty) {
        throw QuantDayException(QuantDayError.invalidParams);
      }

      if (points.length != names.length ||
          weights.length != names.length ||
          days.length != names.length) {
        throw QuantDayException(QuantDayError.invalidParams);
      }

      final List<TaskEntity> tasksToSave = List.generate(names.length, (i) {
        final title = names[i].trim();

        if (title.isEmpty) {
          throw QuantDayException(QuantDayError.invalidParams);
        }

        final rawPoints = points[i];
        final safePoints = (rawPoints?.isNaN ?? true) ? 0.0 : rawPoints!;

        final rawWeight = weights[i];
        final safeWeight = (rawWeight?.isNaN ?? true) ? 1.0 : rawWeight!;

        final rawDay = days[i];
        final formattedDay = (rawDay ?? DateTime.now()).quantDayFormat;

        return TaskEntity(
          id: 0,
          title: title,
          day: formattedDay,
          isFinished: false,
          points: safePoints.clamp(0, 10),
          weight: safeWeight.clamp(1, 5),
        );
      });

      final ids = await _tasksRepository.saveTasks(tasksToSave);

      if (ids.length != tasksToSave.length) {
        throw QuantDayException(QuantDayError.unknown);
      }

      final tasksWithIds = List.generate(tasksToSave.length, (i) {
        return tasksToSave[i].copyWith(id: ids[i]);
      });

      return tasksWithIds;
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
