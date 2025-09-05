import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class ToggleTaskFinishedStatusUseCase {
  final TasksRepository _tasksRepository;

  ToggleTaskFinishedStatusUseCase(this._tasksRepository);

  Future<void> call(TaskEntity task) async {
    try {
      await _tasksRepository.updateTask(
        task.copyWith(isFinished: !task.isFinished),
      );
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
