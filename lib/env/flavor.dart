import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum Flavor { dev, prod }

Flavor getFlavor() {
  if (kIsWeb && kReleaseMode) {
    return Flavor.prod; // --flavor is not supported on web
  }
  return switch (appFlavor) {
    'prod' => Flavor.prod,
    'dev' => Flavor.dev,
    null => Flavor.dev, // if not specified, default to dev
    _ => throw UnsupportedError('Invalid flavor: $appFlavor'),
  };
}
