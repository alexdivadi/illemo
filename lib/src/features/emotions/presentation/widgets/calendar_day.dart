import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_glyph.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_log_tile.dart';
import 'package:illemo/src/features/journal/domain/entities/journal_entry.dart';
import 'package:illemo/src/features/journal/presentation/widgets/journal_paper.dart';

class CalendarDay extends StatelessWidget {
  const CalendarDay({
    super.key,
    required this.date,
    required this.emotionEntries,
    this.journalEntry,
    this.isComplete = false,
  });

  final DateTime date;
  final List<EmotionEntry> emotionEntries;
  final JournalEntry? journalEntry;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final currentDate = DateTime(date.year, date.month, date.day);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      // Minus 2 for border width, minus 6 for padding
      final tileHeight = (constraints.maxHeight - Sizes.p8) / EmotionEntry.maxPerDay;
      return Container(
        margin: const EdgeInsets.all(Sizes.p2),
        decoration: BoxDecoration(
          border: Border.all(
            color: () {
              switch (currentDate.compareTo(today)) {
                case 0:
                  return emotionEntries.isNotEmpty
                      ? isComplete
                          ? Colors.amber
                          : Colors.grey
                      : Colors.grey.withAlpha(75);
                case -1:
                  return emotionEntries.isNotEmpty
                      ? isComplete
                          ? Colors.amber
                          : Colors.grey
                      : Colors.grey.withAlpha(75);
                case 1:
                  return Colors.transparent;
                default:
                  return Colors.transparent;
              }
            }(),
            width: Sizes.p2,
          ),
          borderRadius: BorderRadius.circular(Sizes.p4),
        ),
        child: InkWell(
          onTap: () {
            if (emotionEntries.isNotEmpty || journalEntry != null) {
              showDialog(
                context: context,
                builder: (context) => _DayDialog(
                  date: currentDate,
                  emotionEntries: emotionEntries,
                  journalEntry: journalEntry,
                ),
              );
            }
          },
          child: currentDate.isAfter(today)
              ? SizedBox(
                  height: constraints.maxHeight,
                  child: Stack(
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          radius: 10.0,
                          child: Text(
                            '${currentDate.day}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 9.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : EmotionLogTile(
                  emotions: emotionEntries.map((log) => log.emotion).toList(),
                  height: tileHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.85),
                      radius: 10.0,
                      child: Text(
                        '${currentDate.day}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 9.0,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}

class _DayDialog extends StatelessWidget {
  const _DayDialog({required this.date, required this.emotionEntries, this.journalEntry});

  final DateTime date;
  final List<EmotionEntry> emotionEntries;
  final JournalEntry? journalEntry;

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (emotionEntries.isNotEmpty) _EmotionHeader(entries: emotionEntries),
              if (emotionEntries.isNotEmpty && journalEntry != null) const SizedBox(height: 18),
              if (journalEntry != null)
                JournalPaper(
                  date: journalEntry!.date,
                  minHeight: 220,
                  child: Text(journalEntry!.body, style: JournalPaper.noteStyle),
                ),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      );
}

class _EmotionHeader extends StatelessWidget {
  const _EmotionHeader({required this.entries});

  final List<EmotionEntry> entries;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 76,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Row(
            children: entries
                .map((entry) => Expanded(
                      child: Container(
                        color: entry.category.cardFor(
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).brightness,
                        ),
                        alignment: Alignment.center,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          EmotionGlyph(emotion: entry.category, size: 28),
                          const SizedBox(height: 2),
                          Text(
                            entry.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: entry.category.foregroundOn(
                                entry.category.cardFor(
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context).brightness,
                                ),
                              ),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
}
