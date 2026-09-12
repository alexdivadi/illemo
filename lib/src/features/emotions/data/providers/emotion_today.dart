import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/utils/new_day_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_today.g.dart';

@riverpod
Stream<List<EmotionEntry>> emotionToday(Ref ref) {
  final EmotionRepository emotionRepository = ref.watch(emotionRepositoryProvider);
  ref.watch(newDayStreamProvider);
  return emotionRepository.watchToday();
}
