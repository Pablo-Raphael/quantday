import 'package:quantday/core/constants/habit_categories_database_consts.dart';
import 'package:quantday/core/utils/database_helper.dart';
import 'package:quantday/layers/data/DTOs/habit_category_dto.dart';

class HabitCategoriesDataSource {
  final DataBaseHelper _dataBaseHelper;

  HabitCategoriesDataSource(this._dataBaseHelper);

  Future<int> createHabitCategory(HabitCategoryDTO habitCategory) async {
    final db = await _dataBaseHelper.db;

    return await db.insert(
      HabitCategoriesDatabaseConsts.tableName,
      habitCategory.toMap(),
    );
  }

  Future<List<HabitCategoryDTO>> getHabitCategories() async {
    final db = await _dataBaseHelper.db;

    final maps = await db.query(HabitCategoriesDatabaseConsts.tableName);

    return maps.map((habitCategoryMap) {
      return HabitCategoryDTO.fromMap(habitCategoryMap);
    }).toList();
  }

  Future<int> updateCategory(HabitCategoryDTO habitCategory) async {
    final db = await _dataBaseHelper.db;

    return await db.update(
      HabitCategoriesDatabaseConsts.tableName,
      habitCategory.toMap(),
      where: "${HabitCategoriesDatabaseConsts.id} = ?",
      whereArgs: [habitCategory.id],
    );
  }

  Future<int> deleteHabitCategory(int id) async {
    final db = await _dataBaseHelper.db;

    return await db.delete(
      HabitCategoriesDatabaseConsts.tableName,
      where: '${HabitCategoriesDatabaseConsts.id} = ?',
      whereArgs: [id],
    );
  }
}
