// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_stats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTopEmotionsHash() => r'a98829a2e9adecea82fdfbc123e3ec59cc7e18dc';

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

/// See also [getTopEmotions].
@ProviderFor(getTopEmotions)
const getTopEmotionsProvider = GetTopEmotionsFamily();

/// See also [getTopEmotions].
class GetTopEmotionsFamily extends Family<AsyncValue<List<Emotion>>> {
  /// See also [getTopEmotions].
  const GetTopEmotionsFamily();

  /// See also [getTopEmotions].
  GetTopEmotionsProvider call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return GetTopEmotionsProvider(
      startDate,
      endDate,
    );
  }

  @override
  GetTopEmotionsProvider getProviderOverride(
    covariant GetTopEmotionsProvider provider,
  ) {
    return call(
      provider.startDate,
      provider.endDate,
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
  String? get name => r'getTopEmotionsProvider';
}

/// See also [getTopEmotions].
class GetTopEmotionsProvider extends AutoDisposeStreamProvider<List<Emotion>> {
  /// See also [getTopEmotions].
  GetTopEmotionsProvider(
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
          (ref) => getTopEmotions(
            ref as GetTopEmotionsRef,
            startDate,
            endDate,
          ),
          from: getTopEmotionsProvider,
          name: r'getTopEmotionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTopEmotionsHash,
          dependencies: GetTopEmotionsFamily._dependencies,
          allTransitiveDependencies:
              GetTopEmotionsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  GetTopEmotionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    Stream<List<Emotion>> Function(GetTopEmotionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTopEmotionsProvider._internal(
        (ref) => create(ref as GetTopEmotionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Emotion>> createElement() {
    return _GetTopEmotionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTopEmotionsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetTopEmotionsRef on AutoDisposeStreamProviderRef<List<Emotion>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _GetTopEmotionsProviderElement
    extends AutoDisposeStreamProviderElement<List<Emotion>>
    with GetTopEmotionsRef {
  _GetTopEmotionsProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as GetTopEmotionsProvider).startDate;
  @override
  DateTime get endDate => (origin as GetTopEmotionsProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
