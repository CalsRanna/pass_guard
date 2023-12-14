import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_generator/page/input.dart';
import 'package:password_generator/page/webdav.dart';
import 'package:password_generator/provider/setting.dart';
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
                  Consumer(
                    builder: (_, ref, child) => ListTile(
                      subtitle: const Text('牢记主密码，这是解析加密文件的唯一凭证。'),
                      title: const Text('主密码'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => handleInput(context, ref, '主密码'),
                    ),
                  )
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

  void showAdvance(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Advance()),
    );
  }
}
