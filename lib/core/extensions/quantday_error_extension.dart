import 'package:quantday/core/enums/quantday_error_enum.dart';

extension QuantDayErrorExtension on QuantDayError {
  String get text {
    switch (this) {
      case QuantDayError.moreThanOneRowAffectedInDataBase:
        return 'Mais de uma tarefa foi afetada!';
      case QuantDayError.taskDateParseError:
        return 'Erro ao converter a data de uma ou mais tarefas. '
            'Isso impede que as tarefas sejam exibidas corretamente. '
            'Por favor, entre em contato com o suporte técnico.';
      case QuantDayError.invalidParams:
        return 'Existem campos obrigatórios não preenchidos ou inválidos.';
      case QuantDayError.unknown:
        return 'Erro desconhecido!';
    }
  }
}
