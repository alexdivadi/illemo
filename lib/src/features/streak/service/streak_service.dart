import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/streak/data/streak_repository.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:illemo/src/utils/new_day_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_service.g.dart';

/// A service class that handles streak-related operations.
///
/// This class interacts with the [StreakRepository] to manage streaks,
/// including retrieving the current and longest streaks, and updating streaks.
class StreakService {
  StreakService({
    required this.streakRepository,
  });

  /// The ID used to identify the current streak.
  static const String currentStreakID = 'current';

  /// The ID used to identify the longest streak.
  static const String longestStreakID = 'longest';

  /// The repository used to manage streak data.
  final StreakRepository streakRepository;

  /// Retrieves the current streak from the repository.
  ///
  /// Returns a [Future] that completes with the current [Streak], or `null` if no current streak exists.
  Future<Streak?> getCurrentStreak() async => streakRepository.getStreak(currentStreakID);

  /// Retrieves the longest streak from the repository.
  ///
  /// Returns a [Future] that completes with the longest [Streak], or `null` if no longest streak exists.
  Future<Streak?> getLongestStreak() async => streakRepository.getStreak(longestStreakID);

  /// Retrieves a stream of the longest streak from the repository.
  ///
  /// Returns a [Stream] that emits the longest [Streak] whenever it changes.
  Stream<Streak?> getLongestStreakStream() => streakRepository.getStreakStream(longestStreakID);

  /// Updates the streak in the repository.
  ///
  /// If the provided [streak] has a higher count than the current longest streak,
  /// it updates the longest streak. It also updates the current streak.
  ///
  /// The [streak] parameter is the streak to be updated.
  Future<void> updateStreak(Streak streak) async {
    final longestStreak = await getLongestStreak();
    if (longestStreak == null) {
      await streakRepository.addStreak(streak.copyWith(id: longestStreakID), id: longestStreakID);
    } else if (streak.count > longestStreak.count) {
      await streakRepository.updateStreak(streak.copyWith(id: longestStreakID),
          id: longestStreakID);
    }

    final currentStreak = await getCurrentStreak();
    if (currentStreak == null) {
      await streakRepository.addStreak(streak.copyWith(id: currentStreakID), id: currentStreakID);
    } else {
      await streakRepository.updateStreak(streak.copyWith(id: currentStreakID),
          id: currentStreakID);
    }
  }
}

/// Provides an instance of [StreakService].
@riverpod
StreakService streakService(Ref ref) {
  final StreakRepository streakRepository = ref.watch(streakRepositoryProvider);
  return StreakService(streakRepository: streakRepository);
}

/// Provider for the current [Streak].
///
/// It resets the streak if it is broken.
@riverpod
Future<Streak> streak(Ref ref) async {
  final StreakService streakService = ref.watch(streakServiceProvider);
  ref.watch(newDayStreamProvider);

  final currentStreak = await streakService.getCurrentStreak();
  if (currentStreak != null && currentStreak.isBroken) {
    final brokenStreak = currentStreak.reset();
    await streakService.updateStreak(brokenStreak);
    return brokenStreak;
  }

  return currentStreak ??
      Streak(count: 0, lastUpdated: DateTime.now(), id: StreakService.currentStreakID);
}

/// Provides a stream of the longest [Streak].
@riverpod
Stream<Streak?> longestStreak(Ref ref) {
  final StreakService streakService = ref.watch(streakServiceProvider);
  return streakService.getLongestStreakStream();
}

/// Increments the current streak.
///
/// It forces the [streakProvider] to refresh after updating the streak.
@riverpod
Future<void> incrementStreak(Ref ref) async {
  final streak = await ref.watch(streakProvider.future);
  final updatedStreak = streak.increment();
  final StreakService streakService = ref.read(streakServiceProvider);
  await streakService.updateStreak(updatedStreak);
  ref.invalidate(streakProvider);
}
