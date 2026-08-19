import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/streak/service/streak_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_entry_service.g.dart';

class EmotionEntryService {
  EmotionEntryService({required this.repository, required this.incrementStreak});

  final EmotionRepository repository;
  final Future<void> Function() incrementStreak;

  Future<void> save(EmotionEntry entry) async {
    final wasEmpty = (await repository.watchToday().first).isEmpty;
    await repository.save(entry);
    if (wasEmpty) await incrementStreak();
  }

  Future<void> delete(EmotionEntryID id) => repository.delete(id);
}

@Riverpod(keepAlive: true)
EmotionEntryService emotionEntryService(Ref ref) => EmotionEntryService(
      repository: ref.watch(emotionRepositoryProvider),
      incrementStreak: () => ref.read(incrementStreakProvider.future),
    );
