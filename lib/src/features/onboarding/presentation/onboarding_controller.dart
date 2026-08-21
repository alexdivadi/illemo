import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:illemo/src/features/onboarding/data/onboarding_repository.dart';
import 'package:illemo/src/features/settings/application/reminder_service.dart';
import 'package:illemo/src/features/settings/application/settings_controller.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> completeOnboarding() async {
    final onboardingRepository = ref.watch(onboardingRepositoryProvider).requireValue;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final notificationsEnabled =
          await (await ref.read(reminderServiceProvider.future)).requestPermission();
      await ref.read(settingsControllerProvider.future);
      await ref
          .read(settingsControllerProvider.notifier)
          .setNotificationDefaults(notificationsEnabled);
      await onboardingRepository.setOnboardingComplete();
    });
  }
}
