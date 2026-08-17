import 'package:illemo/src/features/emotions/data/repositories/emotion_entry_repository.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_definition.dart';
import 'package:illemo/src/features/streak/service/streak_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_entry_service.g.dart';

class EmotionEntryService {
  EmotionEntryService({
    required this.entries,
    required this.dailyLogs,
    required this.incrementStreak,
  });

  final EmotionEntryRepository entries;
  final EmotionRepository dailyLogs;
  final Future<void> Function() incrementStreak;

  Future<void> save(EmotionEntry entry) async {
    final before = await entries.watchToday().first;
    await entries.save(entry);
    await _syncDailyLog();
    if (before.isEmpty) await incrementStreak();
  }

  Future<void> delete(String id) async {
    await entries.delete(id);
    await _syncDailyLog();
  }

  Future<void> _syncDailyLog() async {
    final currentEntries = await entries.watchToday().first;
    final currentLog = await dailyLogs.getEmotionLogToday().first;
    if (currentEntries.isEmpty) {
      if (currentLog?.id != null) await dailyLogs.deleteEmotionLog(currentLog!.id!);
      return;
    }

    final log = EmotionLog.fromEmotions(
      emotions: currentEntries.map(_legacyEmotion).toList(),
      date: DateTime.now(),
      id: currentLog?.id,
    );
    if (currentLog?.id == null) {
      await dailyLogs.addEmotionLog(log);
    } else {
      await dailyLogs.updateEmotionLog(currentLog!.id!, log);
    }
  }

  Emotion _legacyEmotion(EmotionEntry entry) {
    final normalized = entry.label.toLowerCase().replaceAll(' ', '');
    for (final emotion in Emotion.values) {
      if (emotion.name.toLowerCase() == normalized) return emotion;
    }
    return switch (entry.core.core) {
      EmotionKey.joy => Emotion.joyful,
      EmotionKey.sadness => Emotion.sad,
      EmotionKey.anger => Emotion.mad,
      EmotionKey.fear => Emotion.scared,
      EmotionKey.disgust => Emotion.critical,
      EmotionKey.surprise => Emotion.surprised,
    };
  }
}

@Riverpod(keepAlive: true)
EmotionEntryService emotionEntryService(Ref ref) => EmotionEntryService(
      entries: ref.watch(emotionEntryRepositoryProvider),
      dailyLogs: ref.watch(emotionRepositoryProvider),
      incrementStreak: () => ref.read(incrementStreakProvider.future),
    );
