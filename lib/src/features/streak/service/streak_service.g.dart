// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streakServiceHash() => r'3bb990fa74e92323b536afa3c12e254b2638be08';

/// See also [streakService].
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
String _$streakHash() => r'517b9f5624a61c7f27cae76aeb18f30de42fde26';

/// Provider for [StreakRepository].
/// Requires [UserID] userID.
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

/// See also [longestStreak].
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
String _$incrementStreakHash() => r'423f29559a92c8cd6e371e6ad710656292e3da16';

/// See also [incrementStreak].
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
