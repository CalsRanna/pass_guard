import 'package:isar/isar.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/setting.dart';
import 'package:password_generator/util/web_dav.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setting.g.dart';

/// Retrieves the remote version from the WebDAV server.
///
/// This function uses the WebDAV client created with the settings provided in the application.
/// The function retrieves the version of the file stored on the remote WebDAV server.
///
/// The [ref] parameter is a reference to the current state of the application.
///
/// Returns a future that completes with the version number if the retrieval was successful,
/// or `null` if the retrieval fails for any reason.
@riverpod
Future<int?> getRemoteVersion(GetRemoteVersionRef ref) async {
  final setting = await ref.watch(settingNotifierProvider.future);
  final client = WebDAVUtil(
    password: setting.webDavPassword,
    path: '',
    url: setting.webDavUrl,
    username: setting.webDavUsername,
  );
  return client.getRemoteVersion();
}

/// [SettingNotifier] is a class that extends from [_$SettingNotifier].
///
/// It is responsible for managing and updating the settings within the application.
/// This includes operations such as building and updating the main password setting.
@riverpod
class SettingNotifier extends _$SettingNotifier {
  @override
  Future<Setting> build() async {
    return await isar.settings.where().findFirst() ?? Setting();
  }

  /// Updates the main password in the application settings.
  ///
  /// This method retrieves the first setting object from the Isar settings,
  /// or creates a new one if none exists. Then, it updates the main password
  /// field of the setting object with the new password provided.
  ///
  /// If the provided password is null, the main password is set to an empty string.
  ///
  /// After the main password is updated, the method writes the new setting
  /// object back into the Isar database and invalidates the provider to
  /// trigger a rebuild of any listening widgets.
  ///
  /// [password] The new password to set. If null, the main password is set to ''.
  Future<void> updateMainPassword(String? password) async {
    var setting = await isar.settings.where().findFirst() ?? Setting();
    setting.mainPassword = password ?? '';
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
    await future;
  }

  /// Updates the sync strategy in the application settings.
  ///
  /// This method retrieves the first setting object from the Isar settings,
  /// or creates a new one if none exists. Then, it updates the sync strategy
  /// field of the setting object with the new strategy provided.
  ///
  /// After the sync strategy is updated, the method writes the new setting
  /// object back into the Isar database and invalidates the provider to
  /// trigger a rebuild of any listening widgets.
  ///
  /// [strategy] The new strategy to set.
  Future<void> updateSyncStrategy(int strategy) async {
    var setting = await isar.settings.where().findFirst() ?? Setting();
    setting.syncStrategy = strategy;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
    await future;
  }

  /// Updates the 'updatedAt' field in the application settings.
  ///
  /// This method retrieves the first setting object from the Isar settings,
  /// or creates a new one if none exists. Then, it updates the 'updatedAt'
  /// field of the setting object with the new DateTime provided.
  ///
  /// If the provided DateTime is null, the 'updatedAt' is set to the current DateTime.
  ///
  /// After the 'updatedAt' is updated, the method writes the new setting
  /// object back into the Isar database and invalidates the provider to
  /// trigger a rebuild of any listening widgets.
  ///
  /// [updatedAt] The new DateTime to set. If null, the 'updatedAt' is set to DateTime.now().
  Future<void> updateUpdatedAt(DateTime? updatedAt) async {
    var setting = await isar.settings.where().findFirst() ?? Setting();
    setting.updatedAt = updatedAt ?? DateTime.now();
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
    await future;
  }

  /// Updates the 'webDavPassword' field in the application settings.
  ///
  /// This method retrieves the first setting object from the Isar settings,
  /// or creates a new one if none exists. Then, it updates the 'webDavPassword'
  /// field of the setting object with the new password provided.
  ///
  /// If the provided password is null, the 'webDavPassword' is set to an empty string.
  ///
  /// After the 'webDavPassword' is updated, the method writes the new setting
  /// object back into the Isar database and invalidates the provider to
  /// trigger a rebuild of any listening widgets.
  ///
  /// [password] The new password to set. If null, the 'webDavPassword' is set to an empty string.
  Future<void> updateWebDavPassword(String? password) async {
    var setting = await isar.settings.where().findFirst() ?? Setting();
    setting.webDavPassword = password ?? '';
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
    await future;
  }

  /// Updates the 'webDavUrl' field in the application settings.
  ///
  /// This method retrieves the first setting object from the Isar settings,
  /// or creates a new one if none exists. Then, it updates the 'webDavUrl'
  /// field of the setting object with the new URL provided.
  ///
  /// If the provided URL is null, the 'webDavUrl' is set to an empty string.
  ///
  /// After the 'webDavUrl' is updated, the method writes the new setting
  /// object back into the Isar database and invalidates the provider to
  /// trigger a rebuild of any listening widgets.
  ///
  /// [url] The new URL to set. If null, the 'webDavUrl' is set to an empty string.
  Future<void> updateWebDavUrl(String? url) async {
    var setting = await isar.settings.where().findFirst() ?? Setting();
    setting.webDavUrl = url ?? '';
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
    await future;
  }

  /// Updates the 'webDavUsername' field in the application settings.
  ///
  /// This method retrieves the first setting object from the Isar settings,
  /// or creates a new one if none exists. Then, it updates the 'webDavUsername'
  /// field of the setting object with the new username provided.
  ///
  /// If the provided username is null, the 'webDavUsername' is set to an empty string.
  ///
  /// After the 'webDavUsername' is updated, the method writes the new setting
  /// object back into the Isar database and invalidates the provider to
  /// trigger a rebuild of any listening widgets.
  ///
  /// [username] The new username to set. If null, the 'webDavUsername' is set to an empty string.
  Future<void> updateWebDavUsername(String? username) async {
    var setting = await isar.settings.where().findFirst() ?? Setting();
    setting.webDavUsername = username ?? '';
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
    await future;
  }
}
