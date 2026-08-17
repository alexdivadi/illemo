---
name: go-router-context-navigation
description: Implement and review Flutter navigation with GoRouter's BuildContext extensions. Use when creating, editing, debugging, or reviewing context.go, context.goNamed, context.push, context.pushNamed, context.pop, context.canPop, context.pushReplacement, context.replace, route parameters, extra data, typed results, redirects, dialogs, nested navigators, or StatefulShellRoute branch navigation.
---

# GoRouter Context Navigation

Use GoRouter's `BuildContext` extensions for routes owned by GoRouter. Choose the method from the intended stack behavior, not from convenience.

## Workflow

1. Inspect `pubspec.lock` for the installed `go_router` version.
2. Read the router configuration, route names, paths, nesting, navigator keys, redirects, and shell branches.
3. Identify whether the action changes app destination, opens a returnable page, closes a page, replaces history, or switches a shell branch.
4. Use a typed result when the caller expects data from a pushed route.
5. Build path and query parameters with `Uri` or named-route parameters instead of manual string concatenation.
6. Guard asynchronous navigation with `context.mounted`.
7. Run `dart format` on changed Dart files and run `dart analyze`.

Follow repository conventions for path constants versus route names. Do not convert the entire routing style unless asked.

## Choose The Method

Use `context.go(location)` when the new location represents the app's destination and the previous page should not be treated as a modal return point:

```dart
context.go(DashboardScreen.path);
```

`go` replaces the current matched route configuration. Prefer it for primary destinations, authentication transitions, success flows, deep links, and redirects.

Use `context.push<T>(location)` when opening a page above the current route and the user should be able to return:

```dart
final document = await context.push<RateConDocument>(
  RateConfirmationsScreen.path,
);

if (!context.mounted || document == null) return;
controller.selectDocument(document);
```

Use `context.pop<T>(result)` to close the current pushed route and optionally complete the caller's `Future<T?>`:

```dart
context.pop<RateConDocument>(document);
```

Use `context.canPop()` before popping when the route might be reached directly or the stack shape is uncertain:

```dart
if (context.canPop()) {
  context.pop();
} else {
  context.go(DashboardScreen.path);
}
```

Use `pushReplacement` when replacing the top page with a new page identity and no return to the old top page is allowed:

```dart
context.pushReplacement(ConfirmationScreen.path);
```

Use `replace` only when replacing the top route while preserving its page key and state identity. This is specialized; do not substitute it casually for `go` or `pushReplacement`.

## Named Routes

Use named variants when the router and surrounding code establish route names as the stable API:

```dart
context.goNamed(
  'detention-form',
  queryParameters: {'type': detentionType},
);

final result = await context.pushNamed<ReviewResult>(
  'detention-review',
  extra: reviewArgs,
);
```

Use:

- `goNamed` for destination navigation.
- `pushNamed<T>` for a returnable page.
- `pushReplacementNamed` for one-way replacement with a new page key.
- `replaceNamed` for same-page-key replacement.
- `namedLocation` when code needs the generated location without navigating.

Keep route names synchronized with the `name` values in `GoRoute`.

## Parameters And Extra

Use `pathParameters` for dynamic path segments and `queryParameters` for URL-visible optional state:

```dart
context.pushNamed(
  'load-details',
  pathParameters: {'loadId': load.id},
  queryParameters: {'tab': 'documents'},
);
```

Use `extra` for in-memory objects that do not belong in the URL:

```dart
context.push(
  ReviewScreen.path,
  extra: ReviewArgs(document: document),
);
```

Treat `extra` as non-restorable and unavailable to external deep links unless the app supplies it separately. Do not force-cast `state.extra` without ensuring every route entry supplies the expected type.

When constructing a path directly, use `Uri`:

```dart
final location = Uri(
  path: DetentionScreen.path,
  queryParameters: {'type': detentionType},
);
context.go(location.toString());
```

## Stateful Shell Routes

For `StatefulShellRoute.indexedStack`, switch tabs through the provided `StatefulNavigationShell`:

```dart
navigationShell.goBranch(
  index,
  initialLocation: index == navigationShell.currentIndex,
);
```

Do not emulate tab switching with `context.push`; that creates duplicate pages and bypasses branch stack preservation. Use `context.go` only when intentionally navigating to a location rather than selecting the shell's branch API.

## GoRouter Versus Navigator

Prefer `context.push`, `context.pop`, and related GoRouter methods for pages declared in the GoRouter configuration.

Use `Navigator` APIs for local imperative routes that are intentionally outside GoRouter, such as a `MaterialPageRoute`, dialog, or a specific root/nested navigator:

```dart
final result = await Navigator.of(
  context,
  rootNavigator: true,
).push<Result>(
  MaterialPageRoute(builder: (_) => const LocalFlowScreen()),
);
```

Pop with the same navigator ownership that presented the route. Do not replace a deliberate `Navigator.of(context, rootNavigator: true)` with `context.pop()` without checking which navigator owns the route.

## Async Safety

After awaiting navigation or other asynchronous work, verify the widget still owns a mounted context:

```dart
final result = await context.push<Result>(ReviewScreen.path);
if (!context.mounted || result == null) return;

context.go(SuccessScreen.path, extra: result);
```

Avoid navigation during `build`. Trigger it from callbacks, lifecycle-safe scheduling, controller effects, or router redirects as appropriate.

## Common Mistakes

- Using `push` for permanent destination changes, leaving unwanted pages in history.
- Using `go` for a selection screen that must return a result.
- Calling `pop` on a directly opened route with nothing beneath it.
- Ignoring the generic type on `push<T>` and relying on casts later.
- Calling `context.pop` for a dialog or page owned by a different navigator.
- Passing required deep-link state only through `extra`.
- Concatenating unescaped query strings manually.
- Calling `context.go` after an `await` without checking `context.mounted`.
- Switching `StatefulShellRoute` tabs with `push`.

## Review Checklist

- Confirm the method matches the intended history behavior.
- Confirm route path or name exists in the router.
- Confirm path and query parameter names match the route declaration.
- Confirm `extra` type matches the route builder.
- Confirm pushed result type matches `pop(result)`.
- Confirm the correct root, shell, or nested navigator owns the route.
- Confirm async uses check `context.mounted`.
- Format changed files and run `dart analyze`.
