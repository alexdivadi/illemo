// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journalRepository)
final journalRepositoryProvider = JournalRepositoryProvider._();

final class JournalRepositoryProvider extends $FunctionalProvider<
    JournalRepository,
    JournalRepository,
    JournalRepository> with $Provider<JournalRepository> {
  JournalRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'journalRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$journalRepositoryHash();

  @$internal
  @override
  $ProviderElement<JournalRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JournalRepository create(Ref ref) {
    return journalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JournalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JournalRepository>(value),
    );
  }
}

String _$journalRepositoryHash() => r'99a876890888b0c124624ea693c19f46b2498fb8';

@ProviderFor(journalToday)
final journalTodayProvider = JournalTodayProvider._();

final class JournalTodayProvider extends $FunctionalProvider<
        AsyncValue<JournalEntry?>, JournalEntry?, Stream<JournalEntry?>>
    with $FutureModifier<JournalEntry?>, $StreamProvider<JournalEntry?> {
  JournalTodayProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'journalTodayProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$journalTodayHash();

  @$internal
  @override
  $StreamProviderElement<JournalEntry?> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<JournalEntry?> create(Ref ref) {
    return journalToday(ref);
  }
}

String _$journalTodayHash() => r'd99a6416e2067b4fb0d7e17950190c2e3a3aa120';

@ProviderFor(journalRange)
final journalRangeProvider = JournalRangeFamily._();

final class JournalRangeProvider extends $FunctionalProvider<
        AsyncValue<List<JournalEntry>>,
        List<JournalEntry>,
        Stream<List<JournalEntry>>>
    with
        $FutureModifier<List<JournalEntry>>,
        $StreamProvider<List<JournalEntry>> {
  JournalRangeProvider._(
      {required JournalRangeFamily super.from,
      required (
        DateTime,
        DateTime,
      )
          super.argument})
      : super(
          retry: null,
          name: r'journalRangeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$journalRangeHash();

  @override
  String toString() {
    return r'journalRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<JournalEntry>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<JournalEntry>> create(Ref ref) {
    final argument = this.argument as (
      DateTime,
      DateTime,
    );
    return journalRange(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JournalRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$journalRangeHash() => r'4dfbe29262c78e31928d90635b0897a149f28f74';

final class JournalRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<JournalEntry>>,
            (
              DateTime,
              DateTime,
            )> {
  JournalRangeFamily._()
      : super(
          retry: null,
          name: r'journalRangeProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  JournalRangeProvider call(
    DateTime start,
    DateTime end,
  ) =>
      JournalRangeProvider._(argument: (
        start,
        end,
      ), from: this);

  @override
  String toString() => r'journalRangeProvider';
}
