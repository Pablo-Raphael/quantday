import 'package:quantday/core/constants/tasks_database_consts.dart';
import 'package:quantday/layers/domain/entities/task.dart';

class TaskDTO {
  final int id;
  final String name;
  final String day;
  final double points;
  final int finished;
  final double weight;

  TaskDTO._({
    required this.id,
    required this.name,
    required this.day,
    required this.points,
    required this.finished,
    required this.weight,
  });

  factory TaskDTO.fromMap(Map map) {
    return TaskDTO._(
      id: map[TasksDatabaseConstants.id],
      name: map[TasksDatabaseConstants.name],
      day: map[TasksDatabaseConstants.day],
      points: map[TasksDatabaseConstants.points],
      weight: map[TasksDatabaseConstants.weight],
      finished: map[TasksDatabaseConstants.finished],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      TasksDatabaseConstants.name: name,
      TasksDatabaseConstants.day: day,
      TasksDatabaseConstants.points: points,
      TasksDatabaseConstants.weight: weight,
      TasksDatabaseConstants.finished: finished,
    };

    if (id > 0) map[TasksDatabaseConstants.id] = id;

    return map;
  }

  factory TaskDTO.fromEntity(TaskEntity task) {
    return TaskDTO._(
      id: task.id,
      name: task.title,
      day: task.day,
      points: task.points,
      weight: task.weight,
      finished: task.isFinished ? 1 : 0,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: name,
      day: day,
      isFinished: finished == 1,
      points: points,
      weight: weight,
    );
  }
}
