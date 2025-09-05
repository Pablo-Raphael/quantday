import 'package:quantday/layers/domain/entities/habit.dart';
import 'edit_dialog_adapter.dart';

class HabitEditDialogAdapter implements EditDialogAdapter {
  final HabitEntity habit;

  const HabitEditDialogAdapter(this.habit);

  @override
  String get dialogDescription =>
      '• Clique no valor para alterá-lo ou '
      'mova o controle deslizante para multiplicar o peso.';

  @override
  String get displayName => habit.name;

  @override
  double? get weight => habit.weight;

  @override
  double? get points => null;

  @override
  bool get isWeighted => true;

  @override
  bool get isFixed => false;

  @override
  HabitEditDialogAdapter copyWith({
    String? displayName,
    double? weight,
    double? points,
  }) {
    return HabitEditDialogAdapter(
      habit.copyWith(name: displayName, weight: weight),
    );
  }

  HabitEntity toEntity() => habit;
}
