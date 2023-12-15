import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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
    // Skip https certificate validation
    dio.httpClientAdapter = IOHttpClientAdapter(
      validateCertificate: (certificate, host, port) {
        return true;
      },
    );
    // Fix cannot be used to imply a default content-type
    dio.options = BaseOptions(contentType: 'application/octet-stream');
    final auth = BasicAuth(user: username, pwd: password);
    _client = Client(uri: url, c: dio, auth: auth);
    // _client = newClient(url, user: username, password: password);
    _path = p.join(path, '.pass_guard', '.vault');
  }

  Future<void> _init() async {
    try {
      await _client.readDir(_path);
    } catch (e) {
      if (e.runtimeType == DioException) {
        final code = (e as DioException).response?.statusCode;
        if (code! >= 400 && code < 500) {
          await _client.mkdirAll(_path);
        }
      }
    }
  }

  Future<int?> getRemoteVersion() async {
    await _init();
    final files = await _client.readDir(_path);
    if (files.isEmpty) return 0;
    files.sort((a, b) => int.parse(b.name!).compareTo(int.parse(a.name!)));
    return int.parse(files.first.name ?? '0');
  }

  Future<void> writeFile(String text, int version) async {
    await _init();
    final path = p.join(_path, '$version');
    final bytes = utf8.encode(text);
    final encodedText = base64.encode(bytes);
    final encodedBytes = encodedText.codeUnits;
    await _client.write(path, Uint8List.fromList(encodedBytes));
  }

  Future<String> readFile(int version) async {
    await _init();
    final encodedBytes = await _client.read(p.join(_path, '$version'));
    final encodedText = String.fromCharCodes(encodedBytes);
    final bytes = base64.decode(encodedText);
    return utf8.decode(bytes);
  }
}
