import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:password_generator/page/form/form.dart';
import 'package:password_generator/page/setting.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/migration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A StatefulWidget that renders a list of passwords.
///
/// This screen is used to display and manage a list of passwords for the user.
/// It allows for operations such as viewing, editing, and deleting passwords.
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
      if (!migrated && mounted) {
        const MigrationRoute().push(context);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Checks if the migration from 'floor' to 'isar' has been completed.
  ///
  /// It queries the 'migrations' collection in the Isar database to check if the
  /// migration named 'floor_to_isar' has been counted. If the count is greater
  /// than zero, it means the migration has already been done.
  ///
  /// Returns a [Future<bool>] that completes with `true` if the migration is done,
  /// otherwise `false`.
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

  void filterList(String? text) async {}

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
    if (route == 'create') {
      const CreateGuardRoute().push(context);
    } else {
      final router = Navigator.of(context);
      Widget page;
      if (route == 'create') {
        page = const PasswordForm();
      } else {
        page = const Setting();
      }
      router.push(MaterialPageRoute(builder: (context) => page));
    }
  }

  /// Navigates to the detail page for a given guard.
  ///
  /// Pushes the [GuardDetailRoute] with the specified [id] onto the navigation
  /// stack to show the detail information of the guard.
  ///
  /// [id] The unique identifier of the guard whose detail is to be shown.
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
