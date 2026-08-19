import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_calendar.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_stats.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_calendar.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_log_tile.dart';
import 'package:illemo/src/features/journal/data/journal_repository.dart';
import 'package:illemo/src/utils/date.dart';
import 'package:illemo/src/utils/pluralize.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key, this.date});

  static const path = "/calendar";
  static const title = "Calendar";

  final DateTime? date;

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final PageController _pageController;
  late DateTime _currentDate;
  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int _pageFor(DateTime date) => (today.year - date.year) * 12 + today.month - date.month;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentDate = widget.date ?? today;
    _pageController = PageController(initialPage: _pageFor(_currentDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              // TODO: This stupid date picker makes the keyboard pop up constantly
              final selectedDate = await showDatePicker(
                context: context,
                keyboardType: TextInputType.datetime,
                initialDate: _currentDate,
                firstDate: DateTime(today.year - 1),
                lastDate: today,
              );
              if (selectedDate != null && context.mounted) {
                setState(() => _currentDate = selectedDate);
                await _pageController.animateToPage(
                  _pageFor(selectedDate),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
        ],
      ),
      body: PageView.builder(
        reverse: true,
        controller: _pageController,
        onPageChanged: (index) => setState(() {
          _currentDate = DateTime(today.year, today.month - index);
        }),
        itemBuilder: (BuildContext context, int index) {
          final targetDate = DateTime(
            today.year,
            today.month - index,
          );
          final emotionEntries = ref.watch(emotionCalendarProvider(targetDate));
          final journalEntries = ref.watch(journalRangeProvider(
            targetDate.startOfMonth,
            targetDate.endOfMonth,
          ));
          final topEmotions = ref.watch(getTopEmotionsProvider(
            targetDate.startOfMonth,
            targetDate.endOfMonth,
          ));
          return Center(
            child: emotionEntries.when(
              data: (emotionEntries) {
                final journals = journalEntries.value;
                if (journalEntries.hasError) {
                  return Center(
                      child: Text('Couldn’t load journal entries. ${journalEntries.error}'));
                }
                if (journals == null) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
                final logsByDay = <String, int>{};
                for (final log in emotionEntries) {
                  logsByDay.update(log.date.date, (count) => count + 1, ifAbsent: () => 1);
                }
                final journalDates = journals.map((entry) => entry.date.date).toSet();
                final numGold = logsByDay.entries
                    .where((entry) =>
                        entry.value == EmotionEntry.maxPerDay && journalDates.contains(entry.key))
                    .length;
                final numTotal = logsByDay.length;
                final totalDays = DateUtils.getDaysInMonth(targetDate.year, targetDate.month);
                return Column(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: EmotionCalendar(
                          emotionEntries: emotionEntries,
                          journalEntries: journals,
                          currentDate: targetDate,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Top Emotions',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  gapH4,
                                  topEmotions.when(
                                      data: (data) {
                                        if (data.isEmpty) {
                                          return const Text('No emotions logged');
                                        }
                                        return Container(
                                          height: 150,
                                          width: double.infinity,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Sizes.p16),
                                          ),
                                          child: EmotionLogTile(
                                            emotions: data,
                                            height: 50,
                                            showNames: true,
                                          ),
                                        );
                                      },
                                      error: (e, st) => const Text('Error loading top emotions'),
                                      loading: () => const CircularProgressIndicator.adaptive()),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(Sizes.p8),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Sizes.p16, vertical: Sizes.p4),
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
                                                style: const TextStyle(
                                                    fontSize: 24, color: Colors.grey),
                                              ),
                                              TextSpan(
                                                text: ' ${"day".pluralize(numTotal)} logged',
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Sizes.p16, vertical: Sizes.p4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.emoji_events, color: Colors.amber),
                                        gapW4,
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '$numGold',
                                                style: const TextStyle(
                                                    fontSize: 24, color: Colors.amber),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
