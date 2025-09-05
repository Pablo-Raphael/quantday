class HabitEntity {
  final int id;
  final int habitCategoryId;
  final String name;
  final double weight;

  HabitEntity({
    required this.id,
    required this.habitCategoryId,
    required this.name,
    required this.weight,
  });

  HabitEntity copyWith({
    int? id,
    int? habitCategoryId,
    String? name,
    double? weight,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      habitCategoryId: habitCategoryId ?? this.habitCategoryId,
      name: name ?? this.name,
      weight: weight ?? this.weight,
    );
  }
}
