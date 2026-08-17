import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/utils/new_day_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_calendar.g.dart';

@riverpod
Stream<List<EmotionLog>> emotionCalendar(Ref ref, DateTime date) {
  final EmotionRepository emotionRepository = ref.watch(emotionRepositoryProvider);
  ref.watch(newDayStreamProvider);

  final startOfMonth = DateTime(date.year, date.month, 1);
  final endOfMonth = DateTime(date.year, date.month + 1, 0);
  return emotionRepository.getEmotionLogs(startDate: startOfMonth, endDate: endOfMonth);
}
