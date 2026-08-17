// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_day_stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A stream that emits a new value every day at midnight.
///
/// This is useful for updating the UI when a new day starts.

@ProviderFor(newDayStream)
final newDayStreamProvider = NewDayStreamProvider._();

/// A stream that emits a new value every day at midnight.
///
/// This is useful for updating the UI when a new day starts.

final class NewDayStreamProvider extends $FunctionalProvider<
        AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  /// A stream that emits a new value every day at midnight.
  ///
  /// This is useful for updating the UI when a new day starts.
  NewDayStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newDayStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newDayStreamHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return newDayStream(ref);
  }
}

String _$newDayStreamHash() => r'c97fd88bb4b5834106945c9161d07090ed611242';
