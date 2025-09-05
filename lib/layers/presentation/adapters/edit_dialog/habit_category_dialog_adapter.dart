import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'edit_dialog_adapter.dart';

class HabitCategoryEditDialogAdapter implements EditDialogAdapter {
  final HabitCategoryEntity habitCategory;

  const HabitCategoryEditDialogAdapter(this.habitCategory);

  @override
  String get dialogDescription => '';

  @override
  String get displayName => habitCategory.title;

  @override
  double? get weight => null;

  @override
  double? get points => null;

  @override
  bool get isWeighted => false;

  @override
  bool get isFixed => false;

  @override
  HabitCategoryEditDialogAdapter copyWith({
    String? displayName,
    double? weight,
    double? points,
  }) {
    return HabitCategoryEditDialogAdapter(
      habitCategory.copyWith(title: displayName),
    );
  }

  HabitCategoryEntity toEntity() => habitCategory;
}
