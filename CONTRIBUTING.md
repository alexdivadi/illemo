# Contributing

Thanks for contributing to Illemo.

1. Open an issue before starting a large change.
2. Keep changes focused and follow [ARCHITECTURE.md](ARCHITECTURE.md).
3. Add or update tests when behavior changes.
4. Before opening a pull request, run:

   ```sh
   dart format .
   flutter analyze
   flutter test
   ```

If annotated Riverpod sources changed, also run:

```sh
dart run build_runner build --delete-conflicting-outputs
```

By contributing, you agree that your contributions are licensed under the
[MIT License](LICENSE.md).
