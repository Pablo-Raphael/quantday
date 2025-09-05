import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class SaveTaskUseCase {
  final TasksRepository _tasksRepository;

  SaveTaskUseCase(this._tasksRepository);

  Future<TaskEntity> call({
    required String name,
    double? points,
    DateTime? day,
  }) async {
    try {
      final taskEntity = TaskEntity(
        id: 0,
        title: name,
        day: day?.quantDayFormat ?? DateTime.now().quantDayFormat,
        isFinished: false,
        points: points?.clamp(0, 10) ?? 0,
        weight: 1,
      );

      final taskId = (await _tasksRepository.saveTasks([taskEntity])).first;

      return taskEntity.copyWith(id: taskId);
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
