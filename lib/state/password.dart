import 'package:creator/creator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/state/global.dart';
import 'package:password_generator/state/setting.dart';

final allPasswordsEmitter = Emitter<List<Password>>((ref, emit) async {
  final database = await ref.read(databaseEmitter);
  final passwords = await database.passwordDao.getAllPasswords();
  emit(passwords);
}, name: 'allPasswordsEmitter');

Emitter<Password?> passwordEmitter(int id) {
  return Emitter((ref, emit) async {
    final database = await ref.read(databaseEmitter);
    final password = await database.passwordDao.findPasswordById(id);
    emit(password);
  }, args: ['password', id], name: 'passwordEmitter_$id');
}

final localVersionCreator = Creator<int>(
  (ref) => Hive.box('setting').get('local_version', defaultValue: 0),
  name: 'localVersionCreator',
);

final remoteVersionEmitter = Emitter<int?>((ref, emit) async {
  final util = ref.watch(webDavUtilCreator);
  final version = await util.getRemoteVersion();
  emit(version);
}, name: 'remoteVersionEmitter');
