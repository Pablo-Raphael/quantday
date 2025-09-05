import 'package:quantday/layers/domain/entities/task.dart';

abstract class TasksRepository {
  Future<List<int>> saveTasks(List<TaskEntity> tasks);

  Future<void> deleteTask(int taskId);

  Future<void> updateTask(TaskEntity task);

  Future<List<TaskEntity>> getTasksOfSpecificDay(DateTime dayDate);

  Future<void> addUncompletedTasksFromPreviousDayToCurrentDay(
    DateTime previousDay,
  );

  Future<Map<DateTime, List<TaskEntity>>> getAllTasks();
}
