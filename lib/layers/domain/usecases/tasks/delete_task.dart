import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class DeleteTaskUseCase {
  final TasksRepository _tasksRepository;

  DeleteTaskUseCase(this._tasksRepository);

  Future<void> call(int taskId) async {
    try {
      await _tasksRepository.deleteTask(taskId);
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
