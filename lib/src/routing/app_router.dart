import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/presentation/screens/calendar.dart';
import 'package:illemo/src/features/emotions/presentation/screens/dashboard.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_confirmation.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';
import 'package:illemo/src/features/onboarding/data/onboarding_repository.dart';
import 'package:illemo/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:illemo/src/features/settings/presentation/settings_screen.dart';
import 'package:illemo/src/routing/not_found_screen.dart';
import 'package:illemo/src/routing/scaffold_with_nested_navigation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _jobsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'jobs');
final _entriesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'entries');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

enum AppRoute {
  onboarding,
  calendar,
  calendarDate,
  emotionPicker,
  emotionConfirmation,
  dashboard,
  settings,
}

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: DashboardScreen.path,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final onboardingRepository = ref.read(onboardingRepositoryProvider).requireValue;
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (path != '/onboarding') {
          return '/onboarding';
        }
        return null;
      }
      if (path.startsWith('/onboarding')) {
        return DashboardScreen.path;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
          path: EmotionPickerScreen.path,
          name: AppRoute.emotionPicker.name,
          builder: (context, state) {
            return EmotionPickerScreen(entry: state.extra as EmotionEntry?);
          }),
      GoRoute(
        path: EmotionConfirmationScreen.path,
        name: AppRoute.emotionConfirmation.name,
        builder: (context, state) => EmotionConfirmationScreen(
          entry: state.extra! as EmotionEntry,
        ),
      ),
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _jobsNavigatorKey,
            routes: [
              GoRoute(
                path: DashboardScreen.path,
                name: AppRoute.dashboard.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _entriesNavigatorKey,
            routes: [
              GoRoute(
                path: CalendarScreen.path,
                name: AppRoute.calendar.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CalendarScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':date',
                    name: AppRoute.calendarDate.name,
                    builder: (context, state) {
                      final date = DateTime.parse(state.pathParameters['date']!);
                      return CalendarScreen(date: date);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: SettingsScreen.path,
                name: AppRoute.settings.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}
