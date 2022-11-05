import 'package:creator/creator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/page/input.dart';
import 'package:password_generator/state/global.dart';
import 'package:password_generator/state/password.dart';
import 'package:password_generator/state/setting.dart';
import 'package:password_generator/util/synchronization.dart';
import 'package:password_generator/widget/message.dart';
import 'package:password_generator/widget/setting_label.dart';

class WebDAV extends StatefulWidget {
  const WebDAV({super.key});

  @override
  State<WebDAV> createState() => _WebDAVState();
}

class _WebDAVState extends State<WebDAV> {
  bool syncing = false;

  final strategies = ['自动校验', '手动选择'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebDAV')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SettingLabel(label: '配置'),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  Watcher(
                    (context, ref, _) => ListTile(
                      subtitle: Text(ref.watch(hostCreator)),
                      title: const Text('服务器地址'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        context,
                        '服务器地址',
                        ref.watch(hostCreator),
                      ),
                    ),
                  ),
                  Watcher(
                    (context, ref, _) => ListTile(
                      subtitle: Text(ref.watch(pathCreator)),
                      title: const Text('路径'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        context,
                        '路径',
                        ref.watch(pathCreator),
                      ),
                    ),
                  ),
                  Watcher(
                    (context, ref, _) => ListTile(
                      subtitle: Text(ref.watch(usernameCreator)),
                      title: const Text('用户名'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        context,
                        '用户名',
                        ref.watch(usernameCreator),
                      ),
                    ),
                  ),
                  Watcher(
                    (context, ref, _) => ListTile(
                      subtitle: Text(ref.watch(passwordCreator)),
                      title: const Text('密码'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        context,
                        '密码',
                        ref.watch(passwordCreator),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Watcher((context, ref, _) {
                return ListTile(
                  subtitle: Text(strategies[ref.watch(syncStrategyCreator)]),
                  title: const Text('同步策略'),
                  trailing: const Icon(Icons.chevron_right_outlined),
                  onTap: () => handleSelect(context),
                );
              }),
            ),
            const SettingLabel(
              label: '当同步策略是自动校验时，将自动选择用版本高的一方覆盖版本低的一方。',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => syncVault(context),
              child: Align(child: Text(syncing ? '同步中' : '同步')),
            ),
            const SettingLabel(
              label: '当密码通过WebDAV同步时，将对你的密码进行加密处理，以保障安全。',
            ),
            const SizedBox(height: 16),
            Align(
              child: Watcher(
                (context, ref, _) => Text(
                  '本地版本：${ref.watch(localVersionCreator)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            Align(
              child: Watcher(
                (context, ref, _) {
                  final style = Theme.of(context).textTheme.bodySmall;
                  try {
                    final remoteVersion =
                        ref.watch(remoteVersionEmitter.asyncData).data;
                    return Text('云端版本：${remoteVersion ?? '无备份'}', style: style);
                  } catch (e) {
                    return Column(
                      children: [
                        Text('云端版本：获取失败', style: style),
                        Text('请检查网络连接或配置信息', style: style)
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleInput(BuildContext context, String label, String value) async {
    final newValue = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingInput(label: label, value: value),
      ),
    );
    if (newValue != null) {
      switch (label) {
        case '服务器地址':
          context.ref.set(hostCreator, newValue);
          Hive.box('setting').put('host', newValue);
          break;
        case '路径':
          context.ref.set(pathCreator, newValue);
          Hive.box('setting').put('path', newValue);
          break;
        case '用户名':
          context.ref.set(usernameCreator, newValue);
          Hive.box('setting').put('username', newValue);
          break;
        case '密码':
          context.ref.set(passwordCreator, newValue);
          Hive.box('setting').put('password', newValue);
          break;
        default:
          break;
      }
    }
  }

  void handleSelect(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 56 * 2 + MediaQuery.of(context).padding.bottom,
        child: Column(
          children: List.generate(
            strategies.length,
            (index) => ListTile(
              title: Text(strategies[index]),
              onTap: () => confirmSelect(context, index),
            ),
          ),
        ),
      ),
    );
  }

  void confirmSelect(BuildContext context, int index) {
    context.ref.set(syncStrategyCreator, index);
    Hive.box('setting').put('sync_strategy', index);
    Navigator.of(context).pop();
  }

  void syncVault(BuildContext context) async {
    if (context.ref.watch(syncStrategyCreator) == 0) {
      await _sync();
    } else {
      manualSync();
    }
  }

  Future<void> manualSync() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 56 * 2 + MediaQuery.of(context).padding.bottom,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined),
              title: const Text('上传'),
              onTap: _upload,
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download_outlined),
              title: const Text('下载'),
              onTap: _download,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _upload() async {
    Navigator.of(context).pop();
    await _sync(direction: 'upload');
  }

  Future<void> _download() async {
    Navigator.of(context).pop();
    await _sync(direction: 'download');
  }

  Future<void> _sync({String? direction}) async {
    setState(() {
      syncing = true;
    });
    final messenger = Message.of(context);
    try {
      final ref = context.ref;
      final util = ref.read(webDavUtilCreator);
      final guards = ref.read(allPasswordsEmitter.asyncData).data;
      final localVersion = ref.read(localVersionCreator);
      final remoteVersion = ref.read(remoteVersionEmitter.asyncData).data;
      final credential = ref.read(mainPasswordCreator);
      final strategy = ref.read(syncStrategyCreator);
      final remoteGuards = await Synchronization.sync(
        util,
        guards,
        localVersion,
        remoteVersion,
        credential,
        strategy,
        direction,
      );
      if (strategy == 0 &&
              remoteVersion != null &&
              remoteVersion >= localVersion ||
          strategy == 1 && direction != null && direction == 'download') {
        _syncRemoteToLocal(remoteGuards);
        messenger.show('下载完毕');
      } else {
        _syncLocalToRemote();
        messenger.show('上传完毕');
      }
      setState(() {
        syncing = false;
      });
    } catch (e) {
      setState(() {
        syncing = false;
      });
      String message;
      if (e.runtimeType == DioError) {
        message = (e as DioError).message;
      } else {
        message = e.toString();
      }
      messenger.show(message);
    }
  }

  void _syncRemoteToLocal(List<Password>? remoteGuards) async {
    final ref = context.ref;
    final remoteVersion = ref.read(remoteVersionEmitter.asyncData).data;
    final database = ref.read(databaseEmitter.asyncData).data;
    await database?.passwordDao.deleteAllPasswords();
    remoteGuards?.forEach((guard) async {
      await database?.passwordDao.insertPassword(guard);
    });
    ref.emit(allPasswordsEmitter, remoteGuards);
    ref.set(localVersionCreator, remoteVersion);
    Hive.box('setting').put('local_version', remoteVersion);
  }

  void _syncLocalToRemote() {
    final ref = context.ref;
    final localVersion = ref.read(localVersionCreator);
    ref.emit(remoteVersionEmitter, localVersion);
  }
}
