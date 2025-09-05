import 'habit.dart';

class HabitCategoryEntity {
  final int id;
  final String title;
  final List<HabitEntity> habits;

  HabitCategoryEntity({
    required this.id,
    required this.title,
    required this.habits,
  });

  HabitCategoryEntity copyWith({
    int? id,
    String? title,
    List<HabitEntity>? habits,
  }) {
    return HabitCategoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      habits: habits ?? this.habits,
    );
  }
}
