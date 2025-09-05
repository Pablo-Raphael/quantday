import 'package:quantday/layers/domain/entities/task.dart';
import 'edit_dialog_adapter.dart';

class TaskEditDialogAdapter implements EditDialogAdapter {
  final TaskEntity task;

  TaskEditDialogAdapter(this.task);

  @override
  String get dialogDescription =>
      '• Clique no valor para alterá-lo ou '
      'mova o controle deslizante para multiplicar o peso.';

  @override
  String get displayName => task.title;

  @override
  double? get weight => task.weight;

  @override
  double? get points => task.points;

  @override
  bool get isWeighted => task.isWeighted;

  @override
  bool get isFixed => task.isFixed;

  @override
  TaskEditDialogAdapter copyWith({
    String? displayName,
    double? weight,
    double? points,
  }) {
    return TaskEditDialogAdapter(
      task.copyWith(title: displayName, weight: weight, points: points),
    );
  }

  TaskEntity toEntity() => task;
}
