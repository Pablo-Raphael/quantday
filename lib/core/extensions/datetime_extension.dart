extension DatetimeExtension on DateTime {
  String get quantDayFormat {
    return toString().split(' ').first;
  }

  DateTime get dateOnly {
    return DateTime(year, month, day);
  }
}
