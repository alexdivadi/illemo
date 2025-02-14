// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emotionRepositoryHash() => r'13ae68e9d0d5907bd2a4b578cb4ff5990be29f78';

/// Firestore implementation of [EmotionRepository].
/// Depends on [firebaseAuthProvider] for user id.
///
/// Copied from [EmotionRepository].
@ProviderFor(EmotionRepository)
final emotionRepositoryProvider =
    AsyncNotifierProvider<EmotionRepository, EmotionLog?>.internal(
  EmotionRepository.new,
  name: r'emotionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emotionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmotionRepository = AsyncNotifier<EmotionLog?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
