import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_entry_repository.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/today_emotion_log.dart';
import 'package:illemo/src/features/emotions/service/emotion_entry_service.dart';
import 'package:illemo/src/features/streak/presentation/streak_widget.dart';
import 'package:illemo/src/features/streak/service/streak_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const path = '/dashboard';
  static const title = 'Dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(emotionEntriesTodayProvider);
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
                    onDelete: (id) => ref.read(emotionEntryServiceProvider).delete(id),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: streak.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (_, __) => const Text('Streak unavailable'),
                          data: (value) => StreakWidget(value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
