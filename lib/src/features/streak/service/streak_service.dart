import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/authentication/domain/app_user.dart';
import 'package:illemo/src/features/streak/data/streak_repository.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:illemo/src/utils/new_day_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_service.g.dart';

class StreakService {
  StreakService({
    required this.streakRepository,
  });

  final StreakRepository streakRepository;

  Future<Streak?> getCurrentStreak() async => streakRepository.getStreak('current');

  Future<Streak?> getLongestStreak() async => streakRepository.getStreak('longest');

  Stream<Streak?> getLongestStreakStream() => streakRepository.getStreakStream('longest');

  /// Creates a new streak in Firestore.
  Future<void> updateStreak(Streak streak) async {
    final longestStreak = await getLongestStreak();
    if (longestStreak == null) {
      await streakRepository.addStreak(streak, id: 'longest');
    } else if (streak.count > longestStreak.count) {
      await streakRepository.updateStreak(streak, id: 'longest');
    }

    final currentStreak = await getCurrentStreak();
    if (currentStreak == null) {
      await streakRepository.addStreak(streak, id: 'current');
    } else {
      await streakRepository.updateStreak(streak, id: 'current');
    }
  }
}

@riverpod
StreakService streakService(Ref ref) {
  final StreakRepository streakRepository = ref.watch(streakRepositoryProvider);
  return StreakService(streakRepository: streakRepository);
}

/// Provider for [StreakRepository].
/// Requires [UserID] userID.
@riverpod
Future<Streak> streak(Ref ref) async {
  final StreakService streakService = ref.watch(streakServiceProvider);
  ref.watch(newDayStreamProvider);

  final currentStreak = await streakService.getCurrentStreak();
  if (currentStreak != null && currentStreak.isBroken) {
    final brokenStreak = Streak(count: 0, lastUpdated: DateTime.now(), id: 'current');
    await streakService.updateStreak(brokenStreak);
    return brokenStreak;
  }

  return currentStreak ?? Streak(count: 0, lastUpdated: DateTime.now(), id: 'current');
}

@riverpod
Stream<Streak?> longestStreak(Ref ref) {
  final StreakService streakService = ref.watch(streakServiceProvider);
  return streakService.getLongestStreakStream();
}

@riverpod
Future<void> incrementStreak(Ref ref) async {
  final streak = await ref.watch(streakProvider.future);
  final updatedStreak = streak.increment();
  final StreakService streakService = ref.read(streakServiceProvider);
  await streakService.updateStreak(updatedStreak);
  // Force the streak provider to refresh
  ref.invalidate(streakProvider);
}
