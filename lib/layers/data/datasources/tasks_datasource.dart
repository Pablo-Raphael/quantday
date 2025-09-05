import 'package:quantday/core/constants/tasks_database_consts.dart';
import 'package:quantday/core/utils/database_helper.dart';
import 'package:quantday/layers/data/DTOs/task_dto.dart';
import 'package:sqflite/sqflite.dart';

class TasksDataSource {
  final DataBaseHelper _dataBaseHelper;

  TasksDataSource(this._dataBaseHelper);

  Future<List<int>> createTasks(List<TaskDTO> tasks) async {
    final db = await _dataBaseHelper.db;

    return await db.transaction((txn) async {
      final batch = txn.batch();

      for (final task in tasks) {
        batch.insert(
          TasksDatabaseConstants.tableName,
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      }

      final results = await batch.commit(
        noResult: false,
        continueOnError: false,
      );

      return results.cast<int>();
    });
  }

  Future<List<TaskDTO>> getTasks(String? day) async {
    final db = await _dataBaseHelper.db;

    final maps = await db.query(
      TasksDatabaseConstants.tableName,
      orderBy: '${TasksDatabaseConstants.day} DESC',
      where: day != null ? '${TasksDatabaseConstants.day} = ?' : null,
      whereArgs: day != null ? [day] : null,
    );

    return maps.map((task) {
      return TaskDTO.fromMap(task);
    }).toList();
  }

  Future<int> updateTask(TaskDTO task) async {
    final db = await _dataBaseHelper.db;

    return await db.update(
      TasksDatabaseConstants.tableName,
      task.toMap(),
      where: '${TasksDatabaseConstants.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await _dataBaseHelper.db;

    return await db.delete(
      TasksDatabaseConstants.tableName,
      where: '${TasksDatabaseConstants.id} = ?',
      whereArgs: [id],
    );
  }
}
