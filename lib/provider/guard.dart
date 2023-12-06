import 'package:isar/isar.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guard.g.dart';

@riverpod
Future<List<Guard>> getAllGuards(GetAllGuardsRef ref) async {
  final guards = await isar.guards.where().findAll();
  return guards;
}

@riverpod
Future<Guard?> findGuard(FindGuardRef ref, int id) async {
  final guard = await isar.guards.get(id);
  return guard;
}

@riverpod
class GuardListNotifier extends _$GuardListNotifier {
  @override
  Future<List<Guard>> build() async {
    final guards = await isar.guards.where().findAll();
    return guards;
  }

  Future<void> addGuard(Guard guard) async {
    await isar.writeTxn(() async {
      await isar.guards.put(guard);
    });
    ref.invalidateSelf();
    await future;
  }
}
