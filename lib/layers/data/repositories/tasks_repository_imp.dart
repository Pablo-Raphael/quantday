import 'package:quantday/core/exceptions/quantday_exception.dart';
import 'package:quantday/core/enums/quantday_error_enum.dart';
import 'package:quantday/layers/data/DTOs/task_dto.dart';
import 'package:quantday/layers/data/datasources/tasks_datasource.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';

class TasksRepositoryImp implements TasksRepository {
  final TasksDataSource _tasksDataSource;

  TasksRepositoryImp(this._tasksDataSource);

  @override
  Future<List<int>> saveTasks(List<TaskEntity> tasks) async {
    final tasksDTOs = tasks.map((task) => TaskDTO.fromEntity(task)).toList();

    return await _tasksDataSource.createTasks(tasksDTOs);
  }

  @override
  Future<void> deleteTask(int taskId) async {
    final affectedRows = await _tasksDataSource.deleteTask(taskId);

    if (affectedRows != 1) {
      throw QuantDayException(QuantDayError.moreThanOneRowAffectedInDataBase);
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final affectedRows = await _tasksDataSource.updateTask(
      TaskDTO.fromEntity(task),
    );

    if (affectedRows != 1) {
      throw QuantDayException(QuantDayError.moreThanOneRowAffectedInDataBase);
    }
  }

  @override
  Future<List<TaskEntity>> getTasksOfSpecificDay(DateTime dayDate) async {
    final tasks = await _tasksDataSource.getTasks(dayDate.quantDayFormat);

    return tasks.map((task) => task.toEntity()).toList();
  }

  @override
  Future<void> addUncompletedTasksFromPreviousDayToCurrentDay(
    DateTime previousDay,
  ) async {
    final tasks = await _tasksDataSource.getTasks(previousDay.quantDayFormat);
    final uncompletedTasks = tasks.where((task) => task.finished == 0).toList();

    final today = DateTime.now().quantDayFormat;
    await _tasksDataSource.createTasks(
      uncompletedTasks.map((task) {
        return TaskDTO.fromEntity(
          task.toEntity().copyWith(id: 0, day: today, points: 0),
        );
      }).toList(),
    );
  }

  @override
  Future<Map<DateTime, List<TaskEntity>>> getAllTasks() async {
    final tasks = await _tasksDataSource.getTasks(null);

    final allTasks = <DateTime, List<TaskEntity>>{};
    for (final task in tasks) {
      final taskEntity = task.toEntity();

      final date = DateTime.tryParse(taskEntity.day);

      if (date == null) {
        throw QuantDayException(QuantDayError.taskDateParseError);
      }

      allTasks.putIfAbsent(date, () => []);
      allTasks[date]!.add(taskEntity);
    }

    return allTasks;
  }
}
