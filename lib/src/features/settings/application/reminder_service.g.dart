// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reminderService)
final reminderServiceProvider = ReminderServiceProvider._();

final class ReminderServiceProvider extends $FunctionalProvider<
        AsyncValue<ReminderService>, ReminderService, FutureOr<ReminderService>>
    with $FutureModifier<ReminderService>, $FutureProvider<ReminderService> {
  ReminderServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reminderServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reminderServiceHash();

  @$internal
  @override
  $FutureProviderElement<ReminderService> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ReminderService> create(Ref ref) {
    return reminderService(ref);
  }
}

String _$reminderServiceHash() => r'10665693df0d97f3cf112bec3332d668db198c16';

@ProviderFor(reminderTaps)
final reminderTapsProvider = ReminderTapsProvider._();

final class ReminderTapsProvider
    extends $FunctionalProvider<AsyncValue<String>, String, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  ReminderTapsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reminderTapsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reminderTapsHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String> create(Ref ref) {
    return reminderTaps(ref);
  }
}

String _$reminderTapsHash() => r'1659af223fc8541e98374e1ef9f6d0c50b54fad7';
