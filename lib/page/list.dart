import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/page/detail.dart';
import 'package:password_generator/page/form.dart';
import 'package:password_generator/page/setting.dart';
import 'package:password_generator/state/global.dart';
import 'package:password_generator/state/password.dart';
import 'package:password_generator/widget/text_icon.dart';

class PasswordList extends StatefulWidget {
  const PasswordList({super.key});

  @override
  State<PasswordList> createState() {
    return _PasswordListState();
  }
}

class _PasswordListState extends State<PasswordList> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();
  bool showTextField = false;

  @override
  void initState() {
    controller = TextEditingController()
      ..addListener(() {
        filterList(controller.text);
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>? actions = [
      IconButton(
        icon: const Icon(Icons.search_outlined),
        onPressed: triggerTextField,
      ),
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => handleNavigated(context, 'setting'),
      ),
    ];

    Widget? title;
    if (showTextField) {
      actions = [
        TextButton(onPressed: triggerTextField, child: const Text('取消'))
      ];
      title = TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '搜索',
        ),
        focusNode: focusNode,
      );
    }
    final body = Watcher((context, ref, _) {
      final passwords = ref.watch(allPasswordsEmitter.asyncData).data;
      if (passwords == null) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else {
        if (passwords.isEmpty) {
          return const Center(child: Text('暂无内容'));
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              leading: TextIcon(
                size: const Size.square(48),
                text: passwords[index].name,
              ),
              subtitle: Text(
                passwords[index].username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              title: Text(
                passwords[index].name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right_outlined),
              onTap: () => showDetail(context, passwords[index].id!),
            ),
            itemCount: passwords.length,
          );
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        actions: actions,
        title: title,
      ),
      body: body,
      floatingActionButton: !showTextField
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () => handleNavigated(context, 'create'),
              child: const Icon(Icons.add_outlined),
            )
          : null,
    );
  }

  void filterList(String? text) async {
    final database = context.ref.watch(databaseEmitter.asyncData).data;
    List<Password>? passwords;
    if (text == null || text.isEmpty) {
      passwords = await database?.passwordDao.getAllPasswords();
    } else {
      passwords = await database?.passwordDao.getPasswordsLikeName('%$text%');
    }
    context.ref.emit(allPasswordsEmitter, passwords);
  }

  void triggerTextField() {
    if (!showTextField) {
      focusNode.requestFocus();
      setState(() {
        showTextField = true;
      });
    } else {
      controller.text = '';
      setState(() {
        showTextField = false;
      });
    }
  }

  void handleNavigated(BuildContext context, String route) {
    final router = Navigator.of(context);
    Widget page;
    if (route == 'create') {
      page = const PasswordForm();
    } else {
      page = const Setting();
    }
    router.push(MaterialPageRoute(builder: (context) => page));
  }

  void showDetail(BuildContext context, int id) {
    final router = Navigator.of(context);
    router.push(
      MaterialPageRoute(builder: (context) => PasswordDetail(id: id)),
    );
  }
}
