import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:password_generator/page/form.dart';
import 'package:password_generator/page/setting.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/migration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((timeStamp) async {
      final migrated = await checkMigration();
      if (!migrated) {
        // ignore: use_build_context_synchronously
        const MigrationRoute().push(context);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> checkMigration() async {
    final count =
        await isar.migrations.filter().nameEqualTo('floor_to_isar').count();
    return count > 0;
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
        IconButton(
          onPressed: triggerTextField,
          icon: const Icon(Icons.close),
        )
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
    return Scaffold(
      appBar: AppBar(
        actions: actions,
        title: title,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final guards = ref.watch(guardListNotifierProvider);
          final a = switch (guards) {
            AsyncData(:final value) => ListView.builder(
                itemBuilder: (_, index) => _GuardListTile(
                  guard: value[index],
                  onTap: () => showDetail(value[index].id),
                ),
                itemCount: value.length,
              ),
            _ => const SizedBox(),
          };
          return a;
        },
      ),
      floatingActionButton: !showTextField
          ? FloatingActionButton(
              onPressed: () => handleNavigated(context, 'create'),
              child: const Icon(Icons.add_outlined),
            )
          : null,
    );
  }

  void filterList(String? text) async {
    // final ref = context.ref;
    // final database = context.ref.watch(databaseEmitter.asyncData).data;
    // List<Password>? passwords;
    // if (text == null || text.isEmpty) {
    //   passwords = await database?.passwordDao.getAllPasswords();
    // } else {
    //   passwords = await database?.passwordDao.getPasswordsLikeName('%$text%');
    // }
    // ref.emit(allPasswordsEmitter, passwords);
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

  void showDetail(int id) {
    GuardDetailRoute(id).push(context);
  }
}

class _GuardListTile extends StatefulWidget {
  const _GuardListTile({required this.guard, this.onTap});

  final Guard guard;
  final void Function()? onTap;

  @override
  State<StatefulWidget> createState() => __GuardListTileState();
}

class __GuardListTileState extends State<_GuardListTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final outlineVariant = colorScheme.outlineVariant;
    final borderSide = BorderSide(color: outlineVariant);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.public_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border(bottom: borderSide)),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.guard.title, style: bodyMedium),
                  Text(buildSubtitle(), style: bodySmall)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String buildSubtitle() {
    final segments = widget.guard.segments;
    for (final segment in segments) {
      final fields = segment.fields;
      for (final field in fields) {
        if (field.value.isNotEmpty) {
          return field.value;
        }
      }
    }
    return '';
  }
}
