import 'package:path/path.dart';
import 'package:quantday/core/constants/habit_categories_database_consts.dart';
import 'package:quantday/core/constants/habits_database_consts.dart';
import 'package:quantday/core/constants/tasks_database_consts.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  Database? _db;

  Future<Database> get db async {
    return _db ??= await initDB();
  }

  Future<Database> initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'quantday.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database database, int version) async {
        await _createSchema(database);
        await _seedV1(database);
      },
    );
  }

  Future<void> _createSchema(Database database) async {
    final batch = database.batch();

    batch.execute('''
      CREATE TABLE ${TasksDatabaseConstants.tableName} (
        ${TasksDatabaseConstants.id} INTEGER PRIMARY KEY,
        ${TasksDatabaseConstants.name} TEXT NOT NULL,
        ${TasksDatabaseConstants.day} TEXT NOT NULL,
        ${TasksDatabaseConstants.points} REAL NOT NULL DEFAULT 0 
          CHECK (${TasksDatabaseConstants.points} >= 0),
        ${TasksDatabaseConstants.weight} REAL NOT NULL DEFAULT 1 
          CHECK (${TasksDatabaseConstants.weight} > 0),
        ${TasksDatabaseConstants.finished} INTEGER NOT NULL DEFAULT 0 
          CHECK (${TasksDatabaseConstants.finished} IN (0,1))
      );
    ''');

    batch.execute('''
      CREATE TABLE ${HabitCategoriesDatabaseConsts.tableName} (
        ${HabitCategoriesDatabaseConsts.id} INTEGER PRIMARY KEY,
        ${HabitCategoriesDatabaseConsts.name} TEXT NOT NULL
      );
    ''');

    batch.execute('''
      CREATE TABLE ${HabitsDatabaseConsts.tableName} (
        ${HabitsDatabaseConsts.id} INTEGER PRIMARY KEY,
        ${HabitsDatabaseConsts.habitCategoryId} INTEGER NOT NULL,
        ${HabitsDatabaseConsts.name} TEXT NOT NULL,
        ${HabitsDatabaseConsts.weight} REAL NOT NULL DEFAULT 1 
          CHECK (${HabitsDatabaseConsts.weight} > 0),
        FOREIGN KEY (${HabitsDatabaseConsts.habitCategoryId})
          REFERENCES ${HabitCategoriesDatabaseConsts.tableName}(${HabitCategoriesDatabaseConsts.id})
          ON UPDATE CASCADE
          ON DELETE CASCADE
      );
    ''');

    batch.execute('''
      CREATE INDEX IF NOT EXISTS idx_${HabitsDatabaseConsts.tableName}_${HabitsDatabaseConsts.habitCategoryId}
      ON ${HabitsDatabaseConsts.tableName} (${HabitsDatabaseConsts.habitCategoryId});
    ''');

    await batch.commit(noResult: true);
  }

  Future<void> _seedV1(Database database) async {
    await database.transaction((txn) async {
      final categoryId = await txn.insert(
        HabitCategoriesDatabaseConsts.tableName,
        {HabitCategoriesDatabaseConsts.name: 'Vida saudável'},
      );

      Future<void> insertHabit(String name, double weight) async {
        await txn.insert(HabitsDatabaseConsts.tableName, {
          HabitsDatabaseConsts.habitCategoryId: categoryId,
          HabitsDatabaseConsts.name: name,
          HabitsDatabaseConsts.weight: weight,
        });
      }

      await insertHabit('Beber 2 litros de água', 2.5);
      await insertHabit('Exercitar-se pela manhã', 4.0);
      await insertHabit('Meditar por 15 minutos', 1.0);
      await insertHabit('Clicar no + adicionará essa categoria', 5.0);
    });
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
