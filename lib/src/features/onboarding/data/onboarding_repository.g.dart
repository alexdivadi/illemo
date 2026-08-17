// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onboardingRepository)
final onboardingRepositoryProvider = OnboardingRepositoryProvider._();

final class OnboardingRepositoryProvider extends $FunctionalProvider<
        AsyncValue<OnboardingRepository>,
        OnboardingRepository,
        FutureOr<OnboardingRepository>>
    with
        $FutureModifier<OnboardingRepository>,
        $FutureProvider<OnboardingRepository> {
  OnboardingRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'onboardingRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$onboardingRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<OnboardingRepository> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<OnboardingRepository> create(Ref ref) {
    return onboardingRepository(ref);
  }
}

String _$onboardingRepositoryHash() =>
    r'445c529dd1ac7515d8be0abd6159af6958ff3c5c';
