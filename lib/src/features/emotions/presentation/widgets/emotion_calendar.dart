import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/calendar_day.dart';

class EmotionCalendar extends StatelessWidget {
  const EmotionCalendar({super.key, required this.emotionLogs, required this.currentDate});

  final List<EmotionLog> emotionLogs;
  final DateTime currentDate;

  static const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  static const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  Widget _buildHeader(DateTime currentDate) {
    final month = currentDate.month;
    final year = currentDate.year;
    final monthName = months[month - 1];

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Text(
        '$monthName $year',
        style: TextStyle(fontSize: Sizes.p24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar(
    List<EmotionLog> emotionLogs,
    DateTime currentDate,
  ) {
    final daysInMonth = DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final weekdayOfFirstDay = firstDayOfMonth.weekday;

    // Create a set of dates with emotion logs for efficient lookup
    final Map<DateTime, EmotionLog> emotionLogDates = {for (var log in emotionLogs) log.date: log};

    // Generate the leading empty days
    final leadingEmptyDays = List.generate(weekdayOfFirstDay - 1, (index) => Container());

    // Generate the days of the month
    final days = List.generate(daysInMonth, (index) {
      final day = firstDayOfMonth.add(Duration(days: index));
      final emotionLog = emotionLogDates[day];
      return CalendarDay(
        date: day,
        emotionLog: emotionLog,
        isComplete: emotionLog != null && emotionLog.emotions.length == EmotionLog.logSize,
      );
    });

    // Combine the leading empty days and the days of the month
    final calendarDays = [...leadingEmptyDays, ...days];

    return GridView.count(
      crossAxisCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      children: calendarDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(currentDate),
        _buildWeekdayLabels(),
        Expanded(child: _buildCalendar(emotionLogs, currentDate)),
      ],
    );
  }
}
