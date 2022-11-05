import 'dart:convert';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/util/web_dav.dart';

class Synchronization {
  static Future<List<Password>?> sync(
    WebDAVUtil util,
    List<Password>? guards,
    int localVersion,
    int? remoteVersion,
    String credential,
    int strategy,
    String? direction,
  ) async {
    try {
      var port = ReceivePort();
      var isolate = await Isolate.spawn(_sync, port.sendPort);
      var sendPort = await port.first as SendPort;
      var reciver = ReceivePort();
      sendPort.send({
        'utilConfig': {
          'url': util.url,
          'path': util.path,
          'username': util.username,
          'password': util.password,
        },
        'guards': const JsonCodec().encode(guards),
        'localVersion': localVersion,
        'remoteVersion': remoteVersion,
        'port': reciver.sendPort,
        'credential': credential,
        'strategy': strategy,
        'direction': direction,
      });
      List<Password>? result;
      await reciver.forEach((message) {
        final text = message as String;
        if (text == 'SYNC_SUCCEED' || text == 'SYNC_FAILED') {
          reciver.close();
          isolate.kill();
        } else if (text.startsWith('SYNC_ERROR:')) {
          reciver.close();
          throw Exception([text.replaceAll('SYNC_ERROR:', '')]);
        } else {
          List json = const JsonCodec().decode(text);
          result = [];
          for (var element in json) {
            result!.add(Password(
              comment: element['comment'],
              id: element['id'],
              name: element['name'],
              username: element['username'],
              password: element['password'],
            ));
          }
        }
      });
      return result;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _sync(SendPort message) async {
    var receivePort = ReceivePort();
    message.send(receivePort.sendPort);
    var args = await receivePort.first as Map<String, dynamic>;
    final utilConfig = args['utilConfig'] as Map<String, String>;
    final localVersion = args['localVersion'] as int;
    final remoteVersion = args['remoteVersion'] as int?;
    final credential = args['credential'] as String;
    final strategy = args['strategy'] as int;
    final direction = args['direction'] as String?;

    final util = WebDAVUtil(
      password: utilConfig['password']!,
      path: utilConfig['path']!,
      url: utilConfig['url']!,
      username: utilConfig['username']!,
    );
    final hash = md5.convert(utf8.encode(credential));
    final key = Key.fromUtf8(hash.toString());
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    const codec = JsonCodec();
    try {
      if (strategy == 0 &&
              remoteVersion != null &&
              remoteVersion >= localVersion ||
          strategy == 1 && direction != null && direction == 'download') {
        final text = await util.readFile(remoteVersion!);
        List json = codec.decode(text);
        List<Password> guards = [];
        for (var element in json) {
          guards.add(Password(
            comment: element['comment'],
            id: element['id'],
            name: element['name'],
            username: element['username'],
            password: encrypter.decrypt(
              Encrypted.fromBase64(element['password']),
              iv: iv,
            ),
          ));
        }
        // json.map((element) {
        //   print(element);
        //   final encryped = element['password'];
        //   final decrypted = encrypter.decrypt(
        //     Encrypted.fromBase64(element['password']),
        //     iv: iv,
        //   );
        //   print(key.toString());
        //   print(encryped.toString());
        //   print(decrypted);
        //   element['password'] = encrypter.decrypt(
        //     Encrypted.fromBase64(element['password']),
        //     iv: iv,
        //   );
        // });
        (args['port'] as SendPort).send(codec.encode(guards));
        (args['port'] as SendPort).send('SYNC_SUCCEED');
      } else {
        final string = args['guards'] as String;
        List json = codec.decode(string);
        List<Password> guards = [];
        for (var element in json) {
          guards.add(Password(
            comment: element['comment'],
            id: element['id'],
            name: element['name'],
            username: element['username'],
            password: encrypter
                .encrypt(
                  element['password'],
                  iv: iv,
                )
                .base64,
          ));
        }
        // json.map((element) {
        //   element['password'] = encrypter
        //       .encrypt(
        //         element['password'],
        //         iv: iv,
        //       )
        //       .base64;
        // });
        final text = codec.encode(guards);
        await util.writeFile(text, localVersion);
        (args['port'] as SendPort).send('SYNC_SUCCEED');
      }
    } catch (e) {
      String message;
      if (e.runtimeType == DioError) {
        message = (e as DioError).message;
      } else {
        message = e.toString();
      }
      (args['port'] as SendPort).send('SYNC_ERROR:$message');
      (args['port'] as SendPort).send('SYNC_FAILED');
    }
  }
}
