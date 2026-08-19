// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_today.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emotionToday)
final emotionTodayProvider = EmotionTodayProvider._();

final class EmotionTodayProvider extends $FunctionalProvider<
        AsyncValue<List<EmotionEntry>>,
        List<EmotionEntry>,
        Stream<List<EmotionEntry>>>
    with
        $FutureModifier<List<EmotionEntry>>,
        $StreamProvider<List<EmotionEntry>> {
  EmotionTodayProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emotionTodayProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emotionTodayHash();

  @$internal
  @override
  $StreamProviderElement<List<EmotionEntry>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<EmotionEntry>> create(Ref ref) {
    return emotionToday(ref);
  }
}

String _$emotionTodayHash() => r'cd4e115f782d855f80e063cb78d10fbb4a3dd534';
