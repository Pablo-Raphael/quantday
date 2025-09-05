import 'package:quantday/core/constants/habit_categories_database_consts.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';

class HabitCategoryDTO {
  final int id;
  final String name;

  HabitCategoryDTO._({required this.id, required this.name});

  factory HabitCategoryDTO.fromMap(Map map) {
    return HabitCategoryDTO._(
      id: map[HabitCategoriesDatabaseConsts.id],
      name: map[HabitCategoriesDatabaseConsts.name],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{HabitCategoriesDatabaseConsts.name: name};

    if (id > 0) map[HabitCategoriesDatabaseConsts.id] = id;

    return map;
  }

  factory HabitCategoryDTO.fromEntity(HabitCategoryEntity habitCategory) {
    return HabitCategoryDTO._(id: habitCategory.id, name: habitCategory.title);
  }

  HabitCategoryEntity toEntity() {
    return HabitCategoryEntity(id: id, title: name, habits: []);
  }
}
