// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_calendar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emotionCalendar)
final emotionCalendarProvider = EmotionCalendarFamily._();

final class EmotionCalendarProvider extends $FunctionalProvider<
        AsyncValue<List<EmotionEntry>>,
        List<EmotionEntry>,
        Stream<List<EmotionEntry>>>
    with
        $FutureModifier<List<EmotionEntry>>,
        $StreamProvider<List<EmotionEntry>> {
  EmotionCalendarProvider._(
      {required EmotionCalendarFamily super.from,
      required DateTime super.argument})
      : super(
          retry: null,
          name: r'emotionCalendarProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emotionCalendarHash();

  @override
  String toString() {
    return r'emotionCalendarProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<EmotionEntry>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<EmotionEntry>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return emotionCalendar(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EmotionCalendarProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$emotionCalendarHash() => r'198d5f527cfda085ce1d132418fcf2e1262020a4';

final class EmotionCalendarFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<EmotionEntry>>, DateTime> {
  EmotionCalendarFamily._()
      : super(
          retry: null,
          name: r'emotionCalendarProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  EmotionCalendarProvider call(
    DateTime date,
  ) =>
      EmotionCalendarProvider._(argument: date, from: this);

  @override
  String toString() => r'emotionCalendarProvider';
}
