// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streakServiceHash() => r'3bb990fa74e92323b536afa3c12e254b2638be08';

/// Provides an instance of [StreakService].
///
/// Copied from [streakService].
@ProviderFor(streakService)
final streakServiceProvider = AutoDisposeProvider<StreakService>.internal(
  streakService,
  name: r'streakServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streakServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StreakServiceRef = AutoDisposeProviderRef<StreakService>;
String _$streakHash() => r'fd03e472ea8a73e9cd7db2453edf89b4de1cdc9c';

/// Provider for the current [Streak].
///
/// It resets the streak if it is broken.
///
/// Copied from [streak].
@ProviderFor(streak)
final streakProvider = AutoDisposeFutureProvider<Streak>.internal(
  streak,
  name: r'streakProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$streakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StreakRef = AutoDisposeFutureProviderRef<Streak>;
String _$longestStreakHash() => r'2ea6fa5d5acdb6f866bcc649ba05e54785ef4b11';

/// Provides a stream of the longest [Streak].
///
/// Copied from [longestStreak].
@ProviderFor(longestStreak)
final longestStreakProvider = AutoDisposeStreamProvider<Streak?>.internal(
  longestStreak,
  name: r'longestStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$longestStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LongestStreakRef = AutoDisposeStreamProviderRef<Streak?>;
String _$incrementStreakHash() => r'4bf2ff28e5cb5dce95bc97b79a0b5c6963ec649c';

/// Increments the current streak.
///
/// It forces the [streakProvider] to refresh after updating the streak.
///
/// Copied from [incrementStreak].
@ProviderFor(incrementStreak)
final incrementStreakProvider = AutoDisposeFutureProvider<void>.internal(
  incrementStreak,
  name: r'incrementStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$incrementStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IncrementStreakRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
