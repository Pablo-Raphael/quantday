class TaskEntity {
  final int id;
  final String title;
  final String day;
  final bool isFinished;
  final double points;
  final double weight;

  TaskEntity({
    required this.id,
    required this.title,
    required this.day,
    required this.isFinished,
    required this.points,
    required this.weight,
  });

  bool get isWeighted => points == 0;

  bool get isFixed => points != 0;

  TaskEntity copyWith({
    int? id,
    String? title,
    String? day,
    bool? isFinished,
    double? points,
    double? weight,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      day: day ?? this.day,
      isFinished: isFinished ?? this.isFinished,
      points: points ?? this.points,
      weight: weight ?? this.weight,
    );
  }
}
