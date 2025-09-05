import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class GetAllTasksGroupedByDayUseCase {
  final TasksRepository _tasksRepository;

  GetAllTasksGroupedByDayUseCase(this._tasksRepository);

  Future<Map<DateTime, List<TaskEntity>>> call() async {
    try {
      final allTasksMap = await _tasksRepository.getAllTasks();

      for (final tasksEntry in allTasksMap.entries) {
        tasksEntry.value.sort((a, b) {
          if (a.isFinished == b.isFinished) return 0;
          if (!a.isFinished && b.isFinished) return -1;
          return 1;
        });
      }

      return allTasksMap;
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
