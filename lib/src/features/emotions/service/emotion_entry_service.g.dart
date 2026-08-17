// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_entry_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emotionEntryService)
final emotionEntryServiceProvider = EmotionEntryServiceProvider._();

final class EmotionEntryServiceProvider extends $FunctionalProvider<
    EmotionEntryService,
    EmotionEntryService,
    EmotionEntryService> with $Provider<EmotionEntryService> {
  EmotionEntryServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emotionEntryServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emotionEntryServiceHash();

  @$internal
  @override
  $ProviderElement<EmotionEntryService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmotionEntryService create(Ref ref) {
    return emotionEntryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmotionEntryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmotionEntryService>(value),
    );
  }
}

String _$emotionEntryServiceHash() =>
    r'1586a1fce24dda186138d471b4ffbe3598e69ced';
