// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getRemoteVersionHash() => r'68e1315b52a59892171b5258849944eb5361a7eb';

/// Retrieves the remote version from the WebDAV server.
///
/// This function uses the WebDAV client created with the settings provided in the application.
/// The function retrieves the version of the file stored on the remote WebDAV server.
///
/// The [ref] parameter is a reference to the current state of the application.
///
/// Returns a future that completes with the version number if the retrieval was successful,
/// or `null` if the retrieval fails for any reason.
///
/// Copied from [getRemoteVersion].
@ProviderFor(getRemoteVersion)
final getRemoteVersionProvider = AutoDisposeFutureProvider<int?>.internal(
  getRemoteVersion,
  name: r'getRemoteVersionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getRemoteVersionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetRemoteVersionRef = AutoDisposeFutureProviderRef<int?>;
String _$settingNotifierHash() => r'5ac7c88f5cdefa69518edb892f7755bf2a5e4281';

/// [SettingNotifier] is a class that extends from [_$SettingNotifier].
///
/// It is responsible for managing and updating the settings within the application.
/// This includes operations such as building and updating the main password setting.
///
/// Copied from [SettingNotifier].
@ProviderFor(SettingNotifier)
final settingNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SettingNotifier, Setting>.internal(
  SettingNotifier.new,
  name: r'settingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingNotifier = AutoDisposeAsyncNotifier<Setting>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
