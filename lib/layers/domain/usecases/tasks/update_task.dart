import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  final TasksRepository _tasksRepository;

  UpdateTaskUseCase(this._tasksRepository);

  Future<void> call(TaskEntity task) async {
    try {
      await _tasksRepository.updateTask(task);
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
