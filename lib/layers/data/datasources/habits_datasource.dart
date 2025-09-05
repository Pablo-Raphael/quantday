import 'package:quantday/core/constants/habits_database_consts.dart';
import 'package:quantday/core/utils/database_helper.dart';
import 'package:quantday/layers/data/DTOs/habit_dto.dart';

class HabitsDataSource {
  final DataBaseHelper _dataBaseHelper;

  HabitsDataSource(this._dataBaseHelper);

  Future<int> createHabit(HabitDTO habit) async {
    final db = await _dataBaseHelper.db;

    return await db.insert(HabitsDatabaseConsts.tableName, habit.toMap());
  }

  Future<List<HabitDTO>> getHabits() async {
    final db = await _dataBaseHelper.db;

    final maps = await db.query(HabitsDatabaseConsts.tableName);

    return maps.map((habitMap) {
      return HabitDTO.fromMap(habitMap);
    }).toList();
  }

  Future<int> updateHabit(HabitDTO habit) async {
    final db = await _dataBaseHelper.db;

    return await db.update(
      HabitsDatabaseConsts.tableName,
      habit.toMap(),
      where: "${HabitsDatabaseConsts.id} = ?",
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await _dataBaseHelper.db;

    return await db.delete(
      HabitsDatabaseConsts.tableName,
      where: '${HabitsDatabaseConsts.id} = ?',
      whereArgs: [id],
    );
  }
}
