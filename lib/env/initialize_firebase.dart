import 'dart:developer';

import 'package:illemo/env/flavor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:illemo/firebase_options_dev.dart' as dev;
import 'package:illemo/firebase_options_prod.dart' as prod;

Future<void> initializeFirebaseApp() async {
  final flavor = getFlavor();
  final firebaseOptions = switch (flavor) {
    Flavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
    Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
  };

  try {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
  } catch (e) {
    log(e.toString(), error: e);
  }
}
