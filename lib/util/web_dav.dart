import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:webdav_client/webdav_client.dart';
import 'package:path/path.dart' as p;

class WebDAVUtil {
  String url;
  String path;
  String username;
  String password;
  late Client _client;
  late String _path;

  WebDAVUtil({
    required this.password,
    required this.path,
    required this.url,
    required this.username,
  }) {
    final dio = WdDio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return client;
    };
    _client = Client(
      uri: url,
      c: dio,
      auth: BasicAuth(user: username, pwd: password),
    );
    _path = p.join(path, '.pass_guard', '.vault');
  }

  Future<void> _init() async {
    try {
      await _client.readDir(_path);
    } catch (e) {
      if (e.runtimeType == DioError) {
        final message = (e as DioError).message;
        if (message == 'Not Found') {
          await _client.mkdirAll(_path);
        }
      }
    }
  }

  Future<int?> getRemoteVersion() async {
    await _init();
    final files = await _client.readDir(_path);
    try {
      if (files.isNotEmpty) {
        int version = 0;
        for (var file in files) {
          final localVersion = int.tryParse(file.name ?? '0') ?? 0;
          if (localVersion > version) {
            version = localVersion;
          }
        }
        return version;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> writeFile(String text, int version) async {
    await _init();
    // 解决中文字符串的codeUnit转码后乱码的问题
    // 先将原本的字符串转换为codeUnits, 再将codeUnits数字直接转换
    // 为[91, 57, 49,<...>]格式的字符串，再将该字符串转换为codeUnits
    await _client.write(
      p.join(_path, '$version'),
      Uint8List.fromList(text.codeUnits.toString().codeUnits),
    );
  }

  Future<String> readFile(int version) async {
    await _init();
    final bytes = await _client.read(p.join(_path, '$version'));
    final string = String.fromCharCodes(bytes);
    final patterns = string
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '')
        .split(',');
    final codeUnits = patterns.map((pattern) => int.parse(pattern)).toList();
    return String.fromCharCodes(codeUnits);
  }
}
