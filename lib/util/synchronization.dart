import 'dart:convert';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
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
    List<Guard>? result;
    await receiver.forEach((message) {
      if (message is Guard) {
        result!.add(message);
      } else {
        isolate.kill();
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
      try {
        final client = WebDAVUtil(
          password: setting.webDavPassword,
          path: '/',
          url: setting.webDavUrl,
          username: setting.webDavUsername,
        );
        final hash = md5.convert(utf8.encode(setting.mainPassword));
        final key = Key.fromUtf8(hash.toString());
        final iv = IV.fromLength(16);
        final encryption = Encrypter(AES(key));
        const codec = JsonCodec();
        if (direction == 'download') {
          print('1');
          final content = await client.readFile(remoteVersion!);
          print('2');
          List json = codec.decode(content);
          List<Guard> remoteGuards = [];
          for (var element in json) {
            element['created_at'] = DateTime.fromMillisecondsSinceEpoch(
              element['created_at'],
            );
            element['updated_at'] = DateTime.fromMillisecondsSinceEpoch(
              element['updated_at'],
            );
            var guard = Guard.fromJson(element);
            final segments = guard.segments;
            for (var segment in segments) {
              final fields = segment.fields;
              for (var field in fields) {
                if (field.type == 'password') {
                  field.value = encryption.decrypt(
                    Encrypted.fromBase64(field.value),
                    iv: iv,
                  );
                }
              }
            }
            remoteGuards.add(guard);
            sender.send(remoteGuards);
          }
          sender.send('CLOSE');
        } else {
          for (var guard in guards) {
            final segments = guard.segments;
            for (var segment in segments) {
              final fields = segment.fields;
              for (var field in fields) {
                if (field.type == 'password') {
                  field.value = encryption
                      .encrypt(
                        field.value,
                        iv: iv,
                      )
                      .base64;
                }
              }
            }
          }
          final json = guards.map((guard) {
            var map = guard.toJson();
            map['created_at'] = guard.createdAt.millisecondsSinceEpoch;
            map['updated_at'] = guard.updatedAt.millisecondsSinceEpoch;
            return map;
          }).toList();
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
