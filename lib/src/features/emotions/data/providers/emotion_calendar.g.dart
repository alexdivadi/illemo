// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_calendar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emotionCalendarHash() => r'b176fe0b5ff9e172d2e5a47336bdd1d8709689b5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [emotionCalendar].
@ProviderFor(emotionCalendar)
const emotionCalendarProvider = EmotionCalendarFamily();

/// See also [emotionCalendar].
class EmotionCalendarFamily extends Family<AsyncValue<List<EmotionLog>>> {
  /// See also [emotionCalendar].
  const EmotionCalendarFamily();

  /// See also [emotionCalendar].
  EmotionCalendarProvider call(
    DateTime date,
  ) {
    return EmotionCalendarProvider(
      date,
    );
  }

  @override
  EmotionCalendarProvider getProviderOverride(
    covariant EmotionCalendarProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'emotionCalendarProvider';
}

/// See also [emotionCalendar].
class EmotionCalendarProvider
    extends AutoDisposeStreamProvider<List<EmotionLog>> {
  /// See also [emotionCalendar].
  EmotionCalendarProvider(
    DateTime date,
  ) : this._internal(
          (ref) => emotionCalendar(
            ref as EmotionCalendarRef,
            date,
          ),
          from: emotionCalendarProvider,
          name: r'emotionCalendarProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$emotionCalendarHash,
          dependencies: EmotionCalendarFamily._dependencies,
          allTransitiveDependencies:
              EmotionCalendarFamily._allTransitiveDependencies,
          date: date,
        );

  EmotionCalendarProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<EmotionLog>> Function(EmotionCalendarRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmotionCalendarProvider._internal(
        (ref) => create(ref as EmotionCalendarRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<EmotionLog>> createElement() {
    return _EmotionCalendarProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmotionCalendarProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EmotionCalendarRef on AutoDisposeStreamProviderRef<List<EmotionLog>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _EmotionCalendarProviderElement
    extends AutoDisposeStreamProviderElement<List<EmotionLog>>
    with EmotionCalendarRef {
  _EmotionCalendarProviderElement(super.provider);

  @override
  DateTime get date => (origin as EmotionCalendarProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
