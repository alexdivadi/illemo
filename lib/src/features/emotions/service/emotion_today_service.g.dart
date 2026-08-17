// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_today_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emotionTodayService)
final emotionTodayServiceProvider = EmotionTodayServiceProvider._();

final class EmotionTodayServiceProvider extends $FunctionalProvider<
    EmotionTodayService,
    EmotionTodayService,
    EmotionTodayService> with $Provider<EmotionTodayService> {
  EmotionTodayServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emotionTodayServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emotionTodayServiceHash();

  @$internal
  @override
  $ProviderElement<EmotionTodayService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmotionTodayService create(Ref ref) {
    return emotionTodayService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmotionTodayService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmotionTodayService>(value),
    );
  }
}

String _$emotionTodayServiceHash() =>
    r'd1f922de4fe5ce0e18ac99c5979a45d74b121cc7';

/// Uploads the emotion log to the server and increments the streak.

@ProviderFor(uploadEmotionLog)
final uploadEmotionLogProvider = UploadEmotionLogFamily._();

/// Uploads the emotion log to the server and increments the streak.

final class UploadEmotionLogProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Uploads the emotion log to the server and increments the streak.
  UploadEmotionLogProvider._(
      {required UploadEmotionLogFamily super.from,
      required (
        List<int>,
        EmotionLogID?,
      )
          super.argument})
      : super(
          retry: null,
          name: r'uploadEmotionLogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$uploadEmotionLogHash();

  @override
  String toString() {
    return r'uploadEmotionLogProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as (
      List<int>,
      EmotionLogID?,
    );
    return uploadEmotionLog(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UploadEmotionLogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$uploadEmotionLogHash() => r'cbb2b2b74746a72682eda2358c00bc10d8304834';

/// Uploads the emotion log to the server and increments the streak.

final class UploadEmotionLogFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<void>,
            (
              List<int>,
              EmotionLogID?,
            )> {
  UploadEmotionLogFamily._()
      : super(
          retry: null,
          name: r'uploadEmotionLogProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Uploads the emotion log to the server and increments the streak.

  UploadEmotionLogProvider call(
    List<int> emotionIds,
    EmotionLogID? id,
  ) =>
      UploadEmotionLogProvider._(argument: (
        emotionIds,
        id,
      ), from: this);

  @override
  String toString() => r'uploadEmotionLogProvider';
}
