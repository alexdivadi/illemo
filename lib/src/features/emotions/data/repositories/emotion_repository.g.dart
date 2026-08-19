// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emotionRepository)
final emotionRepositoryProvider = EmotionRepositoryProvider._();

final class EmotionRepositoryProvider extends $FunctionalProvider<
    EmotionRepository,
    EmotionRepository,
    EmotionRepository> with $Provider<EmotionRepository> {
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

String _$emotionRepositoryHash() => r'b820a896f20d735c04a88fe0b78028b80558d43a';

@ProviderFor(emotionEntriesToday)
final emotionEntriesTodayProvider = EmotionEntriesTodayProvider._();

final class EmotionEntriesTodayProvider extends $FunctionalProvider<
        AsyncValue<List<EmotionEntry>>,
        List<EmotionEntry>,
        Stream<List<EmotionEntry>>>
    with
        $FutureModifier<List<EmotionEntry>>,
        $StreamProvider<List<EmotionEntry>> {
  EmotionEntriesTodayProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emotionEntriesTodayProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emotionEntriesTodayHash();

  @$internal
  @override
  $StreamProviderElement<List<EmotionEntry>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<EmotionEntry>> create(Ref ref) {
    return emotionEntriesToday(ref);
  }
}

String _$emotionEntriesTodayHash() =>
    r'b79dd6a6b96c7765d4dfd867d77252b442180b4c';
