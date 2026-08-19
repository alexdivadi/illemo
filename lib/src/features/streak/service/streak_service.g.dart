// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides an instance of [StreakService].

@ProviderFor(streakService)
final streakServiceProvider = StreakServiceProvider._();

/// Provides an instance of [StreakService].

final class StreakServiceProvider
    extends $FunctionalProvider<StreakService, StreakService, StreakService>
    with $Provider<StreakService> {
  /// Provides an instance of [StreakService].
  StreakServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'streakServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$streakServiceHash();

  @$internal
  @override
  $ProviderElement<StreakService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StreakService create(Ref ref) {
    return streakService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreakService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreakService>(value),
    );
  }
}

String _$streakServiceHash() => r'3bb990fa74e92323b536afa3c12e254b2638be08';

/// Provider for the current [Streak].
///
/// It resets the streak if it is broken.

@ProviderFor(streak)
final streakProvider = StreakProvider._();

/// Provider for the current [Streak].
///
/// It resets the streak if it is broken.

final class StreakProvider
    extends $FunctionalProvider<AsyncValue<Streak>, Streak, FutureOr<Streak>>
    with $FutureModifier<Streak>, $FutureProvider<Streak> {
  /// Provider for the current [Streak].
  ///
  /// It resets the streak if it is broken.
  StreakProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'streakProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$streakHash();

  @$internal
  @override
  $FutureProviderElement<Streak> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Streak> create(Ref ref) {
    return streak(ref);
  }
}

String _$streakHash() => r'fd03e472ea8a73e9cd7db2453edf89b4de1cdc9c';

/// Provides a stream of the longest [Streak].

@ProviderFor(longestStreak)
final longestStreakProvider = LongestStreakProvider._();

/// Provides a stream of the longest [Streak].

final class LongestStreakProvider
    extends $FunctionalProvider<AsyncValue<Streak?>, Streak?, Stream<Streak?>>
    with $FutureModifier<Streak?>, $StreamProvider<Streak?> {
  /// Provides a stream of the longest [Streak].
  LongestStreakProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'longestStreakProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$longestStreakHash();

  @$internal
  @override
  $StreamProviderElement<Streak?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Streak?> create(Ref ref) {
    return longestStreak(ref);
  }
}

String _$longestStreakHash() => r'2ea6fa5d5acdb6f866bcc649ba05e54785ef4b11';

/// Increments the current streak.
///
/// It forces the [streakProvider] to refresh after updating the streak.

@ProviderFor(incrementStreak)
final incrementStreakProvider = IncrementStreakProvider._();

/// Increments the current streak.
///
/// It forces the [streakProvider] to refresh after updating the streak.

final class IncrementStreakProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Increments the current streak.
  ///
  /// It forces the [streakProvider] to refresh after updating the streak.
  IncrementStreakProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'incrementStreakProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$incrementStreakHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return incrementStreak(ref);
  }
}

String _$incrementStreakHash() => r'1c6e71b04797f17a8b1439c8f89500554f094832';
