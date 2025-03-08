import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_calendar.g.dart';

@riverpod
Stream<List<EmotionLog>> emotionCalendar(Ref ref, DateTime date) {
  final EmotionRepository emotionRepository = ref.watch(emotionRepositoryProvider);

  // Anonymous users can only see the current week's emotions
  if (emotionRepository.isOffline) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
    return emotionRepository.getEmotionLogs(startDate: startOfWeek, endDate: endOfWeek);
  }

  // Authenticated users can see the current month's emotions
  final startOfMonth = DateTime(date.year, date.month, 1);
  final endOfMonth = DateTime(date.year, date.month + 1, 0);
  return emotionRepository.getEmotionLogs(startDate: startOfMonth, endDate: endOfMonth);
}
