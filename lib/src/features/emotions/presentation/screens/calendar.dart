import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_calendar.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_calendar.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key, this.date});

  static const path = "/calendar";
  static const title = "Calendar";

  final DateTime? date;

  /// The default date to show the calendar for.
  static final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = date ?? today;
    final emotionLogs = ref.watch(emotionCalendarProvider(currentDate));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Center(
        child: emotionLogs.when(
          data: (emotionLogs) {
            return Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: EmotionCalendar(emotionLogs: emotionLogs, currentDate: currentDate),
            );
          },
          loading: () => const CircularProgressIndicator.adaptive(),
          error: (error, stackTrace) => Text('Error: $error'),
        ),
      ),
    );
  }
}
