import 'package:quantday/core/constants/habits_database_consts.dart';
import 'package:quantday/layers/domain/entities/habit.dart';

class HabitDTO {
  final int id;
  final int habitCategoryId;
  final String name;
  final double weight;

  HabitDTO._({
    required this.id,
    required this.habitCategoryId,
    required this.name,
    required this.weight,
  });

  factory HabitDTO.fromMap(Map map) {
    return HabitDTO._(
      id: map[HabitsDatabaseConsts.id],
      habitCategoryId: map[HabitsDatabaseConsts.habitCategoryId],
      name: map[HabitsDatabaseConsts.name],
      weight: map[HabitsDatabaseConsts.weight],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      HabitsDatabaseConsts.habitCategoryId: habitCategoryId,
      HabitsDatabaseConsts.name: name,
      HabitsDatabaseConsts.weight: weight,
    };

    if (id > 0) map[HabitsDatabaseConsts.id] = id;

    return map;
  }

  factory HabitDTO.fromEntity(HabitEntity habit) {
    return HabitDTO._(
      id: habit.id,
      habitCategoryId: habit.habitCategoryId,
      name: habit.name,
      weight: habit.weight,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      habitCategoryId: habitCategoryId,
      name: name,
      weight: weight,
    );
  }
}
