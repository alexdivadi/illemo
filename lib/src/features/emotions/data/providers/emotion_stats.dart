import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_stats.g.dart';

@riverpod
Stream<List<Emotion>> getTopEmotions(Ref ref, DateTime startDate, DateTime endDate) {
  final EmotionRepository emotionRepository = ref.watch(emotionRepositoryProvider);
  final emotionsStream = emotionRepository.watchRange(startDate, endDate).map((logs) {
    // Process the logs to get the top emotions
    final topEmotions = logs.fold<Map<Emotion, int>>({}, (acc, log) {
      acc[log.emotion] = (acc[log.emotion] ?? 0) + 1;
      return acc;
    });

    // Sort the emotions by count and take the top entries.
    final sortedEmotions = topEmotions.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sortedEmotions.take(EmotionEntry.maxPerDay).map((entry) => entry.key).toList();
  });
  return emotionsStream;
}
