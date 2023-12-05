import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/page/input.dart';
import 'package:password_generator/page/webdav.dart';
import 'package:password_generator/state/setting.dart';
import 'package:password_generator/widget/setting_label.dart';

import 'advance.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingLabel(label: '加密'),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  Watcher(
                    (context, ref, _) => ListTile(
                      subtitle: const Text('牢记主密码，这是解析加密文件的唯一凭证。'),
                      title: const Text('主密码'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(
                        context,
                        '主密码',
                        ref.watch(mainPasswordCreator),
                      ),
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
              child: ListTile(
                title: const Text('WebDAV'),
                trailing: const Icon(Icons.chevron_right_outlined),
                onTap: () => showWebDAV(context),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              margin: EdgeInsets.zero,
              child: ListTile(
                title: const Text('高级'),
                trailing: const Icon(Icons.chevron_right_outlined),
                onTap: () => showAdvance(context),
              ),
            ),
            const Expanded(child: SizedBox()),
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
      ),
    );
  }

  void handleInput(BuildContext context, String label, String value) async {
    final ref = context.ref;
    final newPassword = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingInput(label: label, value: value),
      ),
    );
    if (newPassword != null) {
      ref.set(mainPasswordCreator, newPassword);
      Hive.box('setting').put('main_password', newPassword);
    }
  }

  void showWebDAV(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const WebDAV()),
    );
  }

  void showAdvance(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Advance()),
    );
  }
}
