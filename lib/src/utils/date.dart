extension Date on DateTime {
  String get date => toIso8601String().split('T').first;
}
