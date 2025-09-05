abstract class QuantDayValidators {
  static String? validateName(String? text, {int? maxLength}) {
    if (text == null || text.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    if (maxLength != null && text.length > maxLength) {
      return 'Máximo de $maxLength caracteres';
    }

    return null;
  }

  static String? validatePoints(
    String? text, {
    required double availablePoints,
  }) {
    if (text == null) return 'Valor inválido';

    final points = double.tryParse(text.trim().replaceAll(',', '.')) ?? 0;

    if (points < 0 || points > availablePoints) {
      return 'O valor deve ser maior que 0 e no máximo '
          '${availablePoints.toStringAsFixed(2)} pontos';
    }

    return null;
  }
}
