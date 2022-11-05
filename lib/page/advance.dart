import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/state/global.dart';
import 'package:password_generator/state/password.dart';
import 'package:password_generator/widget/setting_label.dart';

class Advance extends StatelessWidget {
  const Advance({super.key});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.red, fontWeight: FontWeight.w700);
    return Scaffold(
      appBar: AppBar(title: const Text('高级')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: const Text('开源软件声明'),
                trailing: const Icon(Icons.chevron_right_outlined),
                onTap: () => showLicense(context),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => erase(context),
              child: const Align(
                child: Text('擦除所有数据', style: style),
              ),
            ),
            const SettingLabel(
              label: '从此设备中删除所有数据，如果没有通过WebDAV备份，则无法找回。',
            ),
          ],
        ),
      ),
    );
  }

  void showLicense(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    showLicensePage(
      applicationIcon: const Icon(Icons.lock_outline, size: 64),
      applicationLegalese: 'Guard your password only in your own way.',
      applicationName: info.appName,
      applicationVersion: info.version,
      context: context,
    );
  }

  void erase(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('你确定要擦除所有数据吗？'),
        content: const Text('从此设备中删除所有数据，如果没有通过WebDAV备份，则无法找回。'),
        actions: [
          TextButton(
              onPressed: () => cancelErase(context), child: const Text('取消')),
          TextButton(
            onPressed: () => confirmErase(context),
            child: const Text(
              '擦除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void cancelErase(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirmErase(BuildContext context) async {
    final router = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final color = Theme.of(context).colorScheme.primary;
    final database = context.ref.read(databaseEmitter.asyncData).data;
    await database?.passwordDao.deleteAllPasswords();
    context.ref.emit(allPasswordsEmitter, <Password>[]);
    Hive.box('setting').put('local_version', 0);
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: const Text('所有数据已擦除'),
        shape: const StadiumBorder(),
      ),
    );
    router.popUntil(ModalRoute.withName('/'));
  }
}
