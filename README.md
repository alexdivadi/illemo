# Illemo

An emotion journaling app.

## Features

- **Simple onboarding page**
- **Optional authentication** for future backup and synchronization
- **Daily emotion logging**
- **Emotion history and monthly calendar**
- **Emotion trends and streaks**

Emotion history and streaks are stored locally in SQLite and work without an account or network connection.

## Roadmap

- [ ] Add missing tests
- [x] Stateful Nested Navigation (available since GoRouter 7.1)
- [ ] Add localization
- [ ] Responsive UI

> This is a tentative roadmap. There is no ETA for any of the points above. This is a low priority project and I don't have much time to maintain it.

## Relevant Articles

The app is based on my Flutter Riverpod architecture, which is explained in detail here:

- [Flutter App Architecture with Riverpod: An Introduction](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
- [Flutter Project Structure: Feature-first or Layer-first?](https://codewithandrea.com/articles/flutter-project-structure/)
- [Flutter App Architecture: The Repository Pattern](https://codewithandrea.com/articles/flutter-repository-pattern/)
- [How to Build a Robust Flutter App Initialization Flow with Riverpod](https://codewithandrea.com/articles/robust-app-initialization-riverpod/)

More more info on Riverpod, read this:

- [Flutter Riverpod 2.0: The Ultimate Guide](https://codewithandrea.com/articles/flutter-state-management-riverpod/)

## Packages in use

These are the main packages used in the app:

- [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) for data caching, dependency injection, and more
- [Riverpod Generator](https://pub.dev/packages/riverpod_generator) for generated providers
- [GoRouter](https://pub.dev/packages/go_router) for navigation
- [Firebase Auth](https://pub.dev/packages/firebase_auth) and [Firebase UI Auth](https://pub.dev/packages/firebase_ui_auth) for authentication
- [Firebase Analytics](https://pub.dev/packages/firebase_analytics) for automatic app usage events
- [sqflite](https://pub.dev/packages/sqflite) for local emotion history and streak storage
- [Intl](https://pub.dev/packages/intl) for currency, date, time formatting
- [Equatable](https://pub.dev/packages/equatable) to reduce boilerplate code in model classes

See the [pubspec.yaml](pubspec.yaml) file for the complete list.

## Running the project with Firebase

To use this project with Firebase, follow these steps:

- Create a new project with the Firebase console
- Enable Firebase Authentication, along with the Email/Password Authentication Sign-in provider in the Firebase Console (Authentication > Sign-in method > Email/Password > Edit > Enable > Save)
- Enable Google Analytics in both the development and production Firebase projects

Analytics uses the existing flavor-specific Firebase initialization, logs app
opens, and collects the SDK's automatic events. No journal text or emotion records
are sent as custom Analytics events. Verify collection in Analytics DebugView
after rebuilding the app. See the [Firebase Analytics setup guide](https://firebase.google.com/docs/analytics/flutter/get-started).

Then, follow one of the two approaches below. 👇

### 1. Using the CLI

Make sure you have the Firebase CLI and [FlutterFire CLI](https://pub.dev/packages/flutterfire_cli) installed.

Then run this on the terminal from the root of this project:

- Run `firebase login` so you have access to the Firebase project you have created
- Run `flutterfire configure` and follow all the steps

For more info, follow this guide:

- [How to add Firebase to a Flutter app with FlutterFire CLI](https://codewithandrea.com/articles/flutter-firebase-flutterfire-cli/)

That's it. Have fun!

## [License: MIT](LICENSE.md)
