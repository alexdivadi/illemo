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
        AsyncValue<EmotionLog?>, EmotionLog?, Stream<EmotionLog?>>
    with $FutureModifier<EmotionLog?>, $StreamProvider<EmotionLog?> {
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
  $StreamProviderElement<EmotionLog?> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<EmotionLog?> create(Ref ref) {
    return emotionToday(ref);
  }
}

String _$emotionTodayHash() => r'af53ff41f371d4aa12bada3c92e54c3c7506a111';
