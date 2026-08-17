import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_update_helper/force_update_helper.dart';
import 'package:illemo/src/routing/app_router.dart';
import 'package:illemo/src/routing/app_startup.dart';
import 'package:illemo/src/features/settings/application/reminder_service.dart';
import 'package:illemo/src/features/settings/application/settings_controller.dart';
import 'package:illemo/src/utils/alert_dialogs.dart';
import 'package:illemo/src/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final settings = ref.watch(settingsControllerProvider);
    ref.watch(reminderServiceProvider);
    ref.listen(reminderTapsProvider, (_, next) {
      if (next case AsyncData(:final value)) goRouter.go(value);
    });
    return MaterialApp.router(
      routerConfig: goRouter,
      builder: (_, child) {
        // * Important: Use AppStartupWidget to wrap ForceUpdateWidget otherwise you will get this error:
        // * Navigator operation requested with a context that does not include a Navigator.
        // * The context used to push or pop routes from the Navigator must be that of a widget that is a descendant of a Navigator widget.
        return AppStartupWidget(
          onLoaded: (_) => ForceUpdateWidget(
            navigatorKey: goRouter.routerDelegate.navigatorKey,
            forceUpdateClient: ForceUpdateClient(
              // * Real apps should fetch this from an API endpoint or via
              // * Firebase Remote Config
              fetchRequiredVersion: () => Future.value('2.0.0'),
              // * Example ID from this app: https://fluttertips.dev/
              // * To avoid mistakes, store the ID as an environment variable and
              // * read it with String.fromEnvironment
              // TODO: update isoAppStoreId
              iosAppStoreId: '6482293361',
            ),
            allowCancel: false,
            showForceUpdateAlert: (context, allowCancel) => showAlertDialog(
              context: context,
              title: 'App Update Required',
              content: 'Please update to continue using the app.',
              cancelActionText: allowCancel ? 'Later' : null,
              defaultActionText: 'Update Now',
            ),
            showStoreListing: (storeUrl) async {
              if (await canLaunchUrl(storeUrl)) {
                await launchUrl(
                  storeUrl,
                  // * Open app store app directly (or fallback to browser)
                  mode: LaunchMode.externalApplication,
                );
              } else {
                log('Cannot launch URL: $storeUrl');
              }
            },
            onException: (e, st) {
              log(e.toString(), error: e, stackTrace: st);
            },
            child: child!,
          ),
        );
      },
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.value?.darkMode ?? false ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
