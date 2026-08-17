# Agent Instructions

Read `ARCHITECTURE.md` before changing application code. It defines the target architecture; preserve working behavior while migrating toward it in focused, testable steps.

## Required workflow

1. Check `git status` and preserve unrelated user work.
2. Read the full feature flow and search for callers before editing shared code.
3. Reuse existing patterns, helpers, Material APIs, and installed dependencies.
4. Make the smallest change that solves the requested problem at its source.
5. Format, analyze, run focused tests, then inspect the final diff.

## Architecture rules

- Build core features offline-first and usable without authentication.
- Treat SQLite via `sqflite` as the local source of truth. Firestore synchronization is optional and must not block local reads or writes.
- Use SharedPreferences only for small preferences, never collections of application records.
- Keep feature code in presentation, application, domain, and data layers; omit layers that have no code.
- Keep domain rules free of Flutter, Firebase, SQLite, GoRouter, and Riverpod dependencies.
- Put app-wide `ThemeData` and semantic colors in `lib/src/theme/`. Use the theme from widgets instead of new inline app-wide styling.
- Use GoRouter through the established Riverpod router provider. Do not change route paths or payload contracts without an explicit migration.
- Use Riverpod annotations and code generation. Never edit generated `*.g.dart` files by hand.
- Put cross-feature widgets in `common_widgets/`; keep single-feature widgets inside their feature.
- Keep shared immutable values in `constants/` and small stateless cross-feature helpers in `utils/`.
- Use generated Flutter localization for new user-visible copy. Remote Config strings require local defaults.

## Data safety

- Never renumber or replace existing emotion/category IDs.
- Database changes require versioned migrations and migration tests.
- A sign-in or sync operation must never discard local records.
- Do not change Firestore schemas, authentication behavior, or synchronization policy unless the task explicitly includes them.
- Do not add speculative abstractions, dependencies, generated scaffolding, or future-only infrastructure.

## Commands

```sh
dart format .
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Run code generation only when annotated sources changed. Never include unrelated generated churn.
