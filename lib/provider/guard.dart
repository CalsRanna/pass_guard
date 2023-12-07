import 'package:isar/isar.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guard.g.dart';

@riverpod
class GuardListNotifier extends _$GuardListNotifier {
  @override
  Future<List<Guard>> build() async {
    final guards = await isar.guards.where().findAll();
    return guards;
  }

  Future<void> putGuard(Guard guard) async {
    guard.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.guards.put(guard);
    });
    ref.invalidateSelf();
    await future;
  }

  Future<void> destroyGuard(int id) async {
    await isar.writeTxn(() async {
      await isar.guards.delete(id);
    });
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
Future<Guard?> findGuard(FindGuardRef ref, int id) async {
  final guards = await ref.watch(guardListNotifierProvider.future);
  return guards.where((guard) => guard.id == id).firstOrNull;
}
