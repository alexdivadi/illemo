// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_entry_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emotionEntryRepository)
final emotionEntryRepositoryProvider = EmotionEntryRepositoryProvider._();

final class EmotionEntryRepositoryProvider extends $FunctionalProvider<
    EmotionEntryRepository,
    EmotionEntryRepository,
    EmotionEntryRepository> with $Provider<EmotionEntryRepository> {
  EmotionEntryRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emotionEntryRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emotionEntryRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmotionEntryRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmotionEntryRepository create(Ref ref) {
    return emotionEntryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmotionEntryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmotionEntryRepository>(value),
    );
  }
}

String _$emotionEntryRepositoryHash() =>
    r'dc9be37121694490fd2af86445c50db0930dd942';

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
    r'eb0c920ddba81534002b62a826b9716915dba366';
