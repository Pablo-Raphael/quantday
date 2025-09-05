abstract class EditDialogAdapter {
  String get dialogDescription;

  String get displayName;

  double? get weight;

  double? get points;

  bool get isWeighted;

  bool get isFixed;

  EditDialogAdapter copyWith({
    String? displayName,
    double? weight,
    double? points,
  });
}
