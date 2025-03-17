import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/calendar_day.dart';
import 'package:illemo/src/utils/date.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          currentDate: currentDate,
        ),
        const WeekdayLabelsWidget(),
        Expanded(
            child: CalendarWidget(
          emotionLogs: emotionLogs,
          currentDate: currentDate,
        )),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.currentDate});

  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    final month = currentDate.month;
    final year = currentDate.year;
    final monthName = EmotionCalendar.months[month - 1];

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Text(
        '$monthName $year',
        style: TextStyle(fontSize: Sizes.p24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WeekdayLabelsWidget extends StatelessWidget {
  const WeekdayLabelsWidget({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: EmotionCalendar.weekdays.map((day) {
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

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key, required this.emotionLogs, required this.currentDate});

  final List<EmotionLog> emotionLogs;
  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final weekdayOfFirstDay = firstDayOfMonth.weekday;

    // Create a set of dates with emotion logs for efficient lookup
    final Map<String, EmotionLog> emotionLogDates = {
      for (var log in emotionLogs) log.date.date: log
    };

    // Generate the leading empty days
    final leadingEmptyDays = List.generate(weekdayOfFirstDay, (index) => Container());

    // Generate the days of the month
    final days = List.generate(daysInMonth, (index) {
      final day = firstDayOfMonth.add(Duration(days: index, hours: 0));
      final emotionLog = emotionLogDates[day.date];
      return CalendarDay(
        date: day,
        emotionLog: emotionLog,
        isComplete: emotionLog != null && emotionLog.isComplete,
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
}
