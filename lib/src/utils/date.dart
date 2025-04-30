extension Date on DateTime {
  String get date => toIso8601String().split('T').first;

  DateTime get startOfDay => DateTime(year, month, day);
}
