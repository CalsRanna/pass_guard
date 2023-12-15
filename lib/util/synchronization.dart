import 'dart:convert';
import 'dart:isolate';

import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/setting.dart';
import 'package:password_generator/util/web_dav.dart';

class Synchronization {
  static Future<List<Guard>?> sync({
    required Setting setting,
    required List<Guard> guards,
    int? remoteVersion,
    String? direction,
  }) async {
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_sync, sender.sendPort);
    (await sender.first as SendPort).send(
      [setting, guards, remoteVersion, direction, receiver.sendPort],
    );
    List<Guard>? result = [];
    await receiver.forEach((message) {
      if (message is Guard) {
        result.add(message);
      } else {
        isolate.kill();
        if (message != 'CLOSE') {
          throw Exception(message);
        }
        receiver.close();
      }
    });
    return result;
  }

  static Future<void> _sync(SendPort sender) async {
    final receiver = ReceivePort();
    sender.send(receiver.sendPort);
    receiver.listen((message) async {
      final setting = message[0] as Setting;
      final guards = message[1] as List<Guard>;
      final remoteVersion = message[2] as int?;
      final direction = message[3] as String?;
      final sender = message[4] as SendPort;
      receiver.close();
      try {
        final client = WebDAVUtil(
          password: setting.webDavPassword,
          path: '/',
          url: setting.webDavUrl,
          username: setting.webDavUsername,
        );
        const codec = JsonCodec();
        if (direction == 'download') {
          final content = await client.readFile(remoteVersion!);
          List json = codec.decode(content);
          for (var element in json) {
            var guard = Guard.fromJson(element);
            sender.send(guard);
          }
          sender.send('CLOSE');
        } else {
          final json = guards.map((guard) => guard.toJson()).toList();
          final content = codec.encode(json);
          final localVersion = setting.updatedAt.millisecondsSinceEpoch;
          await client.writeFile(content, localVersion);
          sender.send('CLOSE');
        }
      } catch (error) {
        sender.send(error.toString());
      }
    });
  }
}
