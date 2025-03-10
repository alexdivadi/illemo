import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_calendar.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_calendar.dart';
import 'package:illemo/src/routing/app_router.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: DateTime(currentDate.year - 1),
                lastDate: today,
              );
              if (selectedDate != null) {
                if (context.mounted) {
                  context.pushReplacementNamed(AppRoute.calendarDate.name,
                      pathParameters: {'date': selectedDate.toIso8601String().split('T').first});
                }
              }
            },
          ),
        ],
      ),
      body: PageView.builder(
        reverse: true,
        controller: PageController(
            initialPage: (today.year - currentDate.year) * 12 + today.month - currentDate.month),
        itemBuilder: (BuildContext context, int index) {
          final targetDate = DateTime(today.year, today.month - index, today.day);
          final emotionLogs = ref.watch(emotionCalendarProvider(targetDate));
          return Center(
            child: emotionLogs.when(
              data: (emotionLogs) {
                final numGold = emotionLogs.where((log) => log.isComplete).length;
                final numTotal = emotionLogs.length;
                final totalDays = DateUtils.getDaysInMonth(targetDate.year, targetDate.month);
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: EmotionCalendar(emotionLogs: emotionLogs, currentDate: targetDate),
                      ),
                    ),
                    gapH12,
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black54),
                          children: [
                            TextSpan(
                                text: '${(numTotal / totalDays * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: Sizes.p32,
                                )),
                            const TextSpan(
                              text: ' logged',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_events, color: Colors.grey),
                          gapW4,
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$numTotal',
                                  style: const TextStyle(fontSize: 24, color: Colors.grey),
                                ),
                                const TextSpan(
                                  text: ' days logged',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          gapW16,
                          const Icon(Icons.emoji_events, color: Colors.amber),
                          gapW4,
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$numGold',
                                  style: const TextStyle(fontSize: 24, color: Colors.amber),
                                ),
                                const TextSpan(
                                  text: ' complete',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    gapH64,
                  ],
                );
              },
              loading: () => const CircularProgressIndicator.adaptive(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          );
        },
      ),
    );
  }
}
