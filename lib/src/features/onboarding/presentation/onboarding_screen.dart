import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/common_widgets/primary_button.dart';
import 'package:illemo/src/common_widgets/responsive_center.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:illemo/src/localization/string_hardcoded.dart';
import 'package:illemo/src/routing/app_router.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    return Scaffold(
      body: ResponsiveCenter(
        maxContentWidth: 450,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Illemo',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            gapH8,
            Text(
              'Track your emotions daily and improve your mental health',
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            gapH16,
            SvgPicture.asset(
              'assets/common/time-tracking.svg',
              width: 200,
              height: 200,
              semanticsLabel: 'Time tracking logo',
            ),
            gapH16,
            PrimaryButton(
              text: 'Get Started'.hardcoded,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
                      if (context.mounted) {
                        // go to sign in page after completing onboarding
                        context.goNamed(AppRoute.signIn.name);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
