import 'package:quantday/core/enums/quantday_error_enum.dart';

class QuantDayException implements Exception {
  QuantDayError cause;

  QuantDayException(this.cause);
}