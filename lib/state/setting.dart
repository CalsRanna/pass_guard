import 'package:creator/creator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/util/web_dav.dart';

final mainPasswordCreator = Creator<String>(
  (ref) => Hive.box('setting').get('main_password', defaultValue: ''),
  name: 'mainPasswordEmitter',
);

final encryptionCreator = Creator<String>(
  (ref) => Hive.box('setting').get(
    'encryption',
    defaultValue: 'AES with PKCS7 padding',
  ),
  name: 'encryptionCreator',
);

final hostCreator = Creator<String>(
  (ref) => Hive.box('setting').get('host', defaultValue: ''),
  name: 'hostCreator',
);

final pathCreator = Creator<String>(
  (ref) => Hive.box('setting').get('path', defaultValue: ''),
  name: 'pathCreator',
);

final usernameCreator = Creator<String>(
  (ref) => Hive.box('setting').get('username', defaultValue: ''),
  name: 'usernameCreator',
);

final passwordCreator = Creator<String>(
  (ref) => Hive.box('setting').get('password', defaultValue: ''),
  name: 'passwordCreator',
);

final webDavUtilCreator = Creator<WebDAVUtil>((ref) {
  final host = ref.watch(hostCreator);
  final path = ref.watch(pathCreator);
  final username = ref.watch(usernameCreator);
  final password = ref.watch(passwordCreator);
  return WebDAVUtil(
    password: password,
    path: path,
    url: host,
    username: username,
  );
}, name: 'webDavUtilCreator');

final syncStrategyCreator = Creator<int>(
  (ref) => Hive.box('setting').get('sync_strategy', defaultValue: 0),
  name: 'syncStrategyCreator',
);
