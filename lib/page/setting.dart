import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:password_generator/page/input.dart';
import 'package:password_generator/page/webdav.dart';
import 'package:password_generator/provider/setting.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (_, ref, child) => ListTile(
              subtitle: const Text('牢记主密码，这是解析加密文件的唯一凭证。'),
              title: const Text('主密码'),
              trailing: const Icon(Icons.chevron_right_outlined),
              onTap: () => handleInput(context, ref, '主密码'),
            ),
          ),
          ListTile(
            title: const Text('WebDAV'),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () => showWebDAV(context),
          ),
          ListTile(
            title: const Text('开源软件声明'),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () => showLicense(context),
          ),
          const Spacer(),
          Align(
            child: Text(
              'Guard your password only in your own way.',
              style: TextStyle(color: Colors.grey.withOpacity(0.75)),
            ),
          ),
          Align(
            child: Text(
              'Pass Guard Version 1.0.0',
              style: TextStyle(color: Colors.grey.withOpacity(0.75)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ],
      ),
    );
  }

  void showLicense(BuildContext context) {
    PackageInfo.fromPlatform().then(
      (info) => showLicensePage(
        applicationIcon: const Icon(Icons.lock_outline, size: 64),
        applicationLegalese: 'Guard your password only in your own way.',
        applicationName: info.appName,
        applicationVersion: info.version,
        context: context,
      ),
    );
  }

  void handleInput(BuildContext context, WidgetRef ref, String label) async {
    final setting = await ref.read(settingNotifierProvider.future);
    if (!context.mounted) return;
    final mainPassword = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingInput(
          label: label,
          value: setting.mainPassword,
        ),
      ),
    );
    if (mainPassword != null) {
      final notifier = ref.read(settingNotifierProvider.notifier);
      notifier.updateMainPassword(mainPassword);
    }
  }

  void showWebDAV(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const WebDAV()),
    );
  }
}
