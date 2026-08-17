---
name: flutter-dot-shorthands
description: Apply and review Dart dot shorthand syntax in Flutter code. Use when creating, editing, refactoring, or reviewing Dart files in projects whose SDK constraint supports Dart 3.10+, especially for Flutter enums, named constructors, static members, constant expressions, widget properties, theme code, and collection literals.
---

# Flutter Dot Shorthands

Use dot shorthands when Dart can infer the omitted type clearly from the surrounding context. Prefer concise code without weakening readability or type safety.

## Workflow

1. Check `pubspec.yaml` and require a Dart SDK constraint of at least `3.10`.
2. Read the surrounding declaration or parameter type before shortening an expression.
3. Replace the qualifier only when the shorthand resolves to the same member.
4. Keep the explicit type when inference is unclear, the qualifier carries useful meaning, or analysis rejects the shorthand.
5. Run `dart format` on changed Dart files.
6. Run `dart analyze` and fix all introduced issues.

Do not perform broad mechanical rewrites unless the user asks for one. Apply shorthands naturally in code already being changed.

## Preferred Flutter Uses

Prefer shorthand for enum values passed to typed parameters:

```dart
Row(
  mainAxisAlignment: .spaceBetween,
  crossAxisAlignment: .center,
  children: children,
)

Container(
  alignment: .center,
  clipBehavior: .antiAlias,
)

Text(
  label,
  overflow: .ellipsis,
  textAlign: .center,
)
```

Prefer shorthand for constructors whose target type is known:

```dart
const EdgeInsets contentPadding = .symmetric(
  horizontal: 16,
  vertical: 12,
);

final BorderRadius radius = .circular(12);
final ScrollController controller = .new();
```

Prefer shorthand for static members of the inferred type:

```dart
const FontWeight emphasis = .w600;
const Alignment cardAlignment = .topLeft;
```

Use shorthand in typed collections and switch cases:

```dart
const List<Alignment> positions = [.topLeft, .center, .bottomRight];

return switch (status) {
  .idle => idleWidget,
  .loading => loadingWidget,
  .complete => completeWidget,
};
```

Use shorthand on the right side of equality checks:

```dart
if (clipBehavior == .none) {
  return child;
}
```

## Keep Explicit Qualifiers

Do not use shorthand when the member belongs to a different utility class than the expected type:

```dart
const Color color = Colors.red;
const IconData icon = Icons.add;
```

`Color` does not define `red`, and `IconData` does not define `add`, so `.red` and `.add` do not resolve to these values.

Keep the qualifier when there is no clear context type:

```dart
final value = MainAxisAlignment.center;
someUntypedApi(MainAxisAlignment.center);
```

An expression statement cannot begin with a shorthand:

```dart
Logger.log('Saved');
```

Do not place shorthand on the left side of equality:

```dart
if (status == .complete) {
  // Correct.
}
```

Avoid forcing shorthand with casts, extra annotations, or structural rewrites. The shorthand should simplify existing code, not create scaffolding for itself.

## Review Checklist

- Confirm the project uses Dart 3.10 or newer.
- Confirm the context type owns the referenced enum value, constructor, or static member.
- Preserve `const` behavior.
- Keep `Colors.*`, `Icons.*`, and similar namespace-style utility members explicit.
- Prefer shorthand in obvious Flutter property assignments and switch cases.
- Reject changes that reduce clarity or fail analysis.
- Format changed files and run `dart analyze`.

For language edge cases, consult the official Dart dot shorthand documentation: <https://dart.dev/language/dot-shorthands>.
