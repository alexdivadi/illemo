// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_today_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emotionTodayServiceHash() =>
    r'd1f922de4fe5ce0e18ac99c5979a45d74b121cc7';

/// See also [emotionTodayService].
@ProviderFor(emotionTodayService)
final emotionTodayServiceProvider =
    AutoDisposeProvider<EmotionTodayService>.internal(
  emotionTodayService,
  name: r'emotionTodayServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emotionTodayServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmotionTodayServiceRef = AutoDisposeProviderRef<EmotionTodayService>;
String _$uploadEmotionLogHash() => r'1fc7108349f7f60a7238191ac78288e72fd1cf34';

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

/// See also [uploadEmotionLog].
@ProviderFor(uploadEmotionLog)
const uploadEmotionLogProvider = UploadEmotionLogFamily();

/// See also [uploadEmotionLog].
class UploadEmotionLogFamily extends Family<AsyncValue<void>> {
  /// See also [uploadEmotionLog].
  const UploadEmotionLogFamily();

  /// See also [uploadEmotionLog].
  UploadEmotionLogProvider call(
    List<int> emotionIds,
    String? id,
  ) {
    return UploadEmotionLogProvider(
      emotionIds,
      id,
    );
  }

  @override
  UploadEmotionLogProvider getProviderOverride(
    covariant UploadEmotionLogProvider provider,
  ) {
    return call(
      provider.emotionIds,
      provider.id,
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
  String? get name => r'uploadEmotionLogProvider';
}

/// See also [uploadEmotionLog].
class UploadEmotionLogProvider extends AutoDisposeFutureProvider<void> {
  /// See also [uploadEmotionLog].
  UploadEmotionLogProvider(
    List<int> emotionIds,
    String? id,
  ) : this._internal(
          (ref) => uploadEmotionLog(
            ref as UploadEmotionLogRef,
            emotionIds,
            id,
          ),
          from: uploadEmotionLogProvider,
          name: r'uploadEmotionLogProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$uploadEmotionLogHash,
          dependencies: UploadEmotionLogFamily._dependencies,
          allTransitiveDependencies:
              UploadEmotionLogFamily._allTransitiveDependencies,
          emotionIds: emotionIds,
          id: id,
        );

  UploadEmotionLogProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.emotionIds,
    required this.id,
  }) : super.internal();

  final List<int> emotionIds;
  final String? id;

  @override
  Override overrideWith(
    FutureOr<void> Function(UploadEmotionLogRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UploadEmotionLogProvider._internal(
        (ref) => create(ref as UploadEmotionLogRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        emotionIds: emotionIds,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UploadEmotionLogProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UploadEmotionLogProvider &&
        other.emotionIds == emotionIds &&
        other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, emotionIds.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UploadEmotionLogRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `emotionIds` of this provider.
  List<int> get emotionIds;

  /// The parameter `id` of this provider.
  String? get id;
}

class _UploadEmotionLogProviderElement
    extends AutoDisposeFutureProviderElement<void> with UploadEmotionLogRef {
  _UploadEmotionLogProviderElement(super.provider);

  @override
  List<int> get emotionIds => (origin as UploadEmotionLogProvider).emotionIds;
  @override
  String? get id => (origin as UploadEmotionLogProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
