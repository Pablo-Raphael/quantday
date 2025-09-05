import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/layers/domain/repositories/dates_repository.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class GetCurrentDayTasksUseCase {
  final TasksRepository _tasksRepository;
  final DatesRepository _datesRepository;

  GetCurrentDayTasksUseCase(this._tasksRepository, this._datesRepository);

  Future<List<TaskEntity>> call() async {
    try {
      final currentDate = DateTime.now();
      final lastLoadedDate = await _datesRepository.getLastLoadDateOfTasks();

      if (currentDate.quantDayFormat != lastLoadedDate?.quantDayFormat) {
        if (lastLoadedDate != null) {
          await _tasksRepository.addUncompletedTasksFromPreviousDayToCurrentDay(
            lastLoadedDate,
          );
        }
        await _datesRepository.updateLastLoadDateOfTasks(currentDate);
      }

      final tasks = await _tasksRepository.getTasksOfSpecificDay(currentDate);

      tasks.sort((a, b) {
        if (a.isFinished == b.isFinished) return 0;
        if (!a.isFinished && b.isFinished) return -1;
        return 1;
      });

      return tasks;
    } on QuantDayException {
      rethrow;
    } catch (_) {
      throw QuantDayException(QuantDayError.unknown);
    }
  }
}
