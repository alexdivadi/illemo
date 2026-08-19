import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/today_emotion_log.dart';
import 'package:illemo/src/features/emotions/service/emotion_entry_service.dart';
import 'package:illemo/src/features/journal/data/journal_repository.dart';
import 'package:illemo/src/features/streak/presentation/streak_widget.dart';
import 'package:illemo/src/features/streak/service/streak_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const path = '/dashboard';
  static const title = 'Dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(emotionEntriesTodayProvider);
    final journal = ref.watch(journalTodayProvider);
    final streak = ref.watch(streakProvider);
    return Scaffold(
      body: SafeArea(
        child: entries.when(
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, _) => Center(
              child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Couldn’t load today’s feelings. $error'))),
          data: (entries) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                children: [
                  TodayEmotionLog(
                    entries: entries,
                    journalEntry: journal.value,
                    streakBanner: streak.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const Text('Streak unavailable'),
                      data: StreakWidget.new,
                    ),
                    onDelete: (id) => ref.read(emotionEntryServiceProvider).delete(id),
                    onSaveJournal: ref.read(journalRepositoryProvider).saveToday,
                  ),
                  if (entries.length == EmotionEntry.maxPerDay)
                    _CompletionFooter(hasJournal: journal.value != null),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionFooter extends StatelessWidget {
  const _CompletionFooter({required this.hasJournal});

  final bool hasJournal;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 632),
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : const Color(0xFFF0EDE6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          hasJournal
              ? '${EmotionEntry.maxPerDay} feelings and a note logged\nYou’re all done today ✓'
              : '${EmotionEntry.maxPerDay} feelings logged\nAdd a journal note to complete today.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF9B7A66),
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
        ),
      );
}
