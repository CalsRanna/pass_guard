import 'package:isar/isar.dart';
import 'package:password_generator/provider/setting.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/setting.dart';
import 'package:password_generator/util/synchronization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guard.g.dart';

/// Finds and returns a [Guard] object by its [id].
///
/// This method retrieves the list of guards from the [guardListNotifierProvider]
/// and filters it to find the guard with the provided [id].
/// If found, it returns the [Guard] object, otherwise returns null.
///
/// [ref] - The [FindGuardRef] instance to observe the [guardListNotifierProvider].
/// [id] - The unique identifier of the [Guard] object to find.
///
/// Returns [Guard?] - The [Guard] object with the matching [id] or null if not found.
@riverpod
Future<Guard?> findGuard(FindGuardRef ref, int id) async {
  final guards = await ref.watch(guardListNotifierProvider.future);
  return guards.where((guard) => guard.id == id).firstOrNull;
}

/// Manages a list of [Guard] objects by interfacing with the Isar database.
///
/// This notifier provides asynchronous operations to read and modify the list
/// of guards. It includes methods to retrieve all guards, add or update a single
/// guard, and delete a guard by id. Changes to the list are persisted in the
/// Isar database and will trigger an update to all listeners.
@riverpod
class GuardListNotifier extends _$GuardListNotifier {
  @override
  Future<List<Guard>> build() async {
    final guards = await isar.guards.where().findAll();
    return guards;
  }

  /// Deletes a [Guard] object from the Isar database by its id.
  ///
  /// This method performs a write transaction to delete the guard with the given [id].
  /// Once the transaction is complete, the notifier is invalidated to reflect the changes.
  ///
  /// [id] - The unique identifier of the [Guard] object to be deleted.
  ///
  /// Throws an [IsarError] if the transaction fails.
  Future<void> destroyGuard(int id) async {
    await isar.writeTxn(() async {
      await isar.guards.delete(id);
    });
    ref.invalidateSelf();
    await future;
  }

  /// Filters the guards whose titles contain the given [value].
  ///
  /// If the [value] is empty, it invalidates the state to refresh the guards list.
  /// Otherwise, it queries the Isar database for guards with titles that contain
  /// the specified [value], and updates the state with the result.
  ///
  /// Throws an [IsarError] if the database query fails.
  Future<void> filterGuards(String value) async {
    if (value.isEmpty) {
      ref.invalidateSelf();
    } else {
      final guards = await isar.guards.filter().titleContains(value).findAll();
      state = AsyncData(guards);
    }
  }

  /// Persists a [Guard] object to the Isar database.
  ///
  /// This method updates the [updatedAt] field of the [Guard] object
  /// with the current date and time, then creates or updates the guard
  /// in the database within a write transaction. After the transaction,
  /// the notifier is invalidated to reflect the changes.
  ///
  /// [guard] - The [Guard] object to be persisted to the database.
  ///
  /// Throws an [IsarError] if the transaction fails.
  Future<void> putGuard(Guard guard) async {
    guard.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.guards.put(guard);
    });
    ref.invalidateSelf();
    await future;
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateUpdatedAt(guard.updatedAt);
  }

  Future<void> uploadGuards() async {
    final guards = state.value;
    if (guards == null) return;
    final setting = await ref.read(settingNotifierProvider.future);
    await Synchronization.sync(
      setting: setting,
      guards: guards,
      direction: 'upload',
    );
    ref.invalidate(getRemoteVersionProvider);
  }

  Future<void> downloadGuards() async {
    var setting = await ref.read(settingNotifierProvider.future);
    final version = await ref.read(getRemoteVersionProvider.future);
    final guards = await Synchronization.sync(
      setting: setting,
      guards: [],
      direction: 'download',
      remoteVersion: version,
    );
    if (guards == null) return;
    state = AsyncData(guards);
    await isar.writeTxn(() async {
      await isar.guards.clear();
      await isar.guards.putAll(guards);
    });
    setting.updatedAt = DateTime.fromMillisecondsSinceEpoch(version ?? 0);
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
  }
}
