// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_day_stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newDayStreamHash() => r'c97fd88bb4b5834106945c9161d07090ed611242';

/// A stream that emits a new value every day at midnight.
///
/// This is useful for updating the UI when a new day starts.
///
/// Copied from [newDayStream].
@ProviderFor(newDayStream)
final newDayStreamProvider = AutoDisposeStreamProvider<DateTime>.internal(
  newDayStream,
  name: r'newDayStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newDayStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NewDayStreamRef = AutoDisposeStreamProviderRef<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
