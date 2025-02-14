// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_repository_local.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emotionRepositoryLocalHash() => r'685a805fb855d044572d0d97ad9dfa374c88c82b';

/// Local implementation of [EmotionRepository].
/// Depends on [sharedPreferencesProvider] for storing data.
///
/// Copied from [EmotionRepositoryLocal].
@ProviderFor(EmotionRepositoryLocal)
final emotionRepositoryLocalProvider =
    AsyncNotifierProvider<EmotionRepositoryLocal, EmotionLog?>.internal(
  EmotionRepositoryLocal.new,
  name: r'emotionRepositoryLocalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$emotionRepositoryLocalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmotionRepositoryLocal = AsyncNotifier<EmotionLog?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
