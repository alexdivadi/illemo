// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for [EmotionRepository].

@ProviderFor(emotionRepository)
final emotionRepositoryProvider = EmotionRepositoryProvider._();

/// Provider for [EmotionRepository].

final class EmotionRepositoryProvider extends $FunctionalProvider<
    EmotionRepository,
    EmotionRepository,
    EmotionRepository> with $Provider<EmotionRepository> {
  /// Provider for [EmotionRepository].
  EmotionRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emotionRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emotionRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmotionRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmotionRepository create(Ref ref) {
    return emotionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmotionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmotionRepository>(value),
    );
  }
}

String _$emotionRepositoryHash() => r'19d45bd30134b92359d7a9099479c48b0f9877c9';
