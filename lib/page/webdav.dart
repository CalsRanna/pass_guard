import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_generator/page/input.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/provider/setting.dart';
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
        child: Consumer(builder: (_, ref, child) {
          final provider = ref.watch(settingNotifierProvider);
          final setting = switch (provider) {
            AsyncData(:final value) => value,
            _ => null,
          };
          final remoteVersionProvider = ref.watch(getRemoteVersionProvider);
          final version = switch (remoteVersionProvider) {
            AsyncData(:final value) => value,
            _ => null,
          };

          return ListView(
            children: [
              const SettingLabel(label: '配置'),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      subtitle: Text(setting?.webDavUrl ?? ''),
                      title: const Text('服务器地址'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        ref,
                        '服务器地址',
                        setting?.webDavUrl,
                      ),
                    ),
                    ListTile(
                      subtitle: Text(setting?.webDavUsername ?? ''),
                      title: const Text('用户名'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        ref,
                        '用户名',
                        setting?.webDavUsername,
                      ),
                    ),
                    ListTile(
                      subtitle: Text(setting?.webDavPassword ?? ''),
                      title: const Text('密码'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        ref,
                        '密码',
                        setting?.webDavPassword,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Consumer(builder: (_, ref, child) {
                  final setting = ref.watch(settingNotifierProvider);
                  final strategy = switch (setting) {
                    AsyncData(:final value) => value.syncStrategy,
                    _ => 0,
                  };
                  return ListTile(
                    subtitle: Text(strategies[strategy]),
                    title: const Text('同步策略'),
                    trailing: const Icon(Icons.chevron_right_outlined),
                    onTap: handleSelect,
                  );
                }),
              ),
              const SettingLabel(
                label: '当同步策略是自动校验时，将自动选择用版本高的一方覆盖版本低的一方。',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => syncVault(ref),
                child: Align(child: Text(syncing ? '同步中' : '同步')),
              ),
              const SettingLabel(
                label: '当密码通过WebDAV同步时，将对你的密码进行加密处理，以保障安全。',
              ),
              const SizedBox(height: 16),
              Align(
                child: Text(
                  '本地版本：${setting?.updatedAt.millisecondsSinceEpoch}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Align(
                child: Text(
                  '云端版本：${version ?? 0}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void handleInput(WidgetRef ref, String label, String? value) async {
    final newValue = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingInput(label: label, value: value),
      ),
    );
    final notifier = ref.read(settingNotifierProvider.notifier);
    if (newValue != null) {
      switch (label) {
        case '服务器地址':
          notifier.updateWebDavUrl(newValue);
          break;
        case '用户名':
          notifier.updateWebDavUsername(newValue);
          break;
        case '密码':
          notifier.updateWebDavPassword(newValue);
          break;
        default:
          break;
      }
    }
  }

  void handleSelect() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 56 * 2 + MediaQuery.of(context).padding.bottom,
        child: Consumer(
          builder: (_, ref, child) => Column(
            children: List.generate(
              strategies.length,
              (index) => ListTile(
                title: Text(strategies[index]),
                onTap: () => confirmSelect(ref, index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void confirmSelect(WidgetRef ref, int index) {
    Navigator.of(context).pop();
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateSyncStrategy(index);
  }

  void syncVault(WidgetRef ref) async {
    final setting = await ref.read(settingNotifierProvider.future);
    if (setting.syncStrategy == 0) {
      await confirmSync(ref);
    } else {
      manualSync(ref);
    }
  }

  Future<void> manualSync(WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 56 * 2 + MediaQuery.of(context).padding.bottom,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined),
              title: const Text('上传'),
              onTap: () => confirmSync(ref, direction: 'upload'),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download_outlined),
              title: const Text('下载'),
              onTap: () => confirmSync(ref, direction: 'download'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmSync(WidgetRef ref, {String? direction}) async {
    setState(() {
      syncing = true;
    });
    print(syncing);
    final messenger = Message.of(context);
    try {
      final setting = await ref.read(settingNotifierProvider.future);
      final localVersion = setting.updatedAt.millisecondsSinceEpoch;
      final remoteVersion = await ref.read(getRemoteVersionProvider.future);
      final conditionA = setting.syncStrategy == 0;
      final conditionB = remoteVersion != null && remoteVersion >= localVersion;
      final conditionC = setting.syncStrategy == 1;
      final conditionD = direction == 'download';
      final notifier = ref.read(guardListNotifierProvider.notifier);
      if (conditionA && conditionB || conditionC && conditionD) {
        print('download');
        await notifier.downloadGuards();
        messenger.show('下载完毕');
      } else {
        print('upload');
        await notifier.uploadGuards();
        messenger.show('上传完毕');
      }
      setState(() {
        syncing = false;
      });
      print(syncing);
    } catch (e) {
      setState(() {
        syncing = false;
      });
    }
  }
}
