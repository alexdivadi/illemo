// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_stats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getTopEmotions)
final getTopEmotionsProvider = GetTopEmotionsFamily._();

final class GetTopEmotionsProvider extends $FunctionalProvider<
        AsyncValue<List<Emotion>>, List<Emotion>, Stream<List<Emotion>>>
    with $FutureModifier<List<Emotion>>, $StreamProvider<List<Emotion>> {
  GetTopEmotionsProvider._(
      {required GetTopEmotionsFamily super.from,
      required (
        DateTime,
        DateTime,
      )
          super.argument})
      : super(
          retry: null,
          name: r'getTopEmotionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getTopEmotionsHash();

  @override
  String toString() {
    return r'getTopEmotionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Emotion>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Emotion>> create(Ref ref) {
    final argument = this.argument as (
      DateTime,
      DateTime,
    );
    return getTopEmotions(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetTopEmotionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getTopEmotionsHash() => r'63fa529d267c760c4961e3fa00e04142219419c4';

final class GetTopEmotionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<Emotion>>,
            (
              DateTime,
              DateTime,
            )> {
  GetTopEmotionsFamily._()
      : super(
          retry: null,
          name: r'getTopEmotionsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GetTopEmotionsProvider call(
    DateTime startDate,
    DateTime endDate,
  ) =>
      GetTopEmotionsProvider._(argument: (
        startDate,
        endDate,
      ), from: this);

  @override
  String toString() => r'getTopEmotionsProvider';
}
