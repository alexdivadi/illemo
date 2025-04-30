extension Date on DateTime {
  String get date => toIso8601String().split('T').first;

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get startOfYear => DateTime(year, 1, 1);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);
  DateTime get endOfYear => DateTime(year + 1, 1, 0, 23, 59, 59);
}
