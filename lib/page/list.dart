import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:password_generator/page/form/form.dart';
import 'package:password_generator/page/setting.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/migration.dart';

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
  FocusNode focusNode = FocusNode();
  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    List<Widget>? actions = [
      Consumer(
        builder: (_, ref, child) => IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () => triggerTextField(ref),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => handleNavigated(context, 'setting'),
      ),
    ];

    Widget? title;
    if (showTextField) {
      actions = [
        Consumer(
          builder: (_, ref, child) => IconButton(
            onPressed: () => triggerTextField(ref),
            icon: const Icon(Icons.close),
          ),
        )
      ];
      title = Consumer(
        builder: (_, ref, child) => TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '搜索',
          ),
          focusNode: focusNode,
          onSubmitted: (value) => filterGuards(ref, value),
        ),
      );
    }
    Widget? floatingActionButton;
    if (!showTextField) {
      floatingActionButton = FloatingActionButton(
        onPressed: createPassword,
        child: const Icon(Icons.add_outlined),
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
          final consumer = switch (guards) {
            AsyncData(:final value) => ListView.separated(
                // itemBuilder: (_, index) => _GuardListTile(
                //   guard: value[index],
                //   onTap: () => showDetail(value[index].id),
                // ),
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  height: 1,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    value[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    value[index].subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Container(
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.public_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onTap: () => showDetail(value[index].id),
                ),
                itemCount: value.length,
              ),
            _ => const SizedBox(),
          };
          return consumer;
        },
      ),
      floatingActionButton: floatingActionButton,
    );
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

  void createPassword() {
    const CreateGuardRoute().push(context);
  }

  /// Filters the list of guards based on the given [value].
  ///
  /// If [value] is empty, it triggers a refresh of the guards list.
  /// Otherwise, it performs a search query in the Isar database for guards
  /// with titles that contain the [value], and updates the state with the results.
  ///
  /// [ref] is the WidgetRef from the Riverpod context.
  /// [value] is the search term used to filter the guards list.
  ///
  /// Throws an [IsarError] if the database query fails.
  void filterGuards(WidgetRef ref, String value) {
    final notifier = ref.read(guardListNotifierProvider.notifier);
    notifier.filterGuards(value);
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

  @override
  void initState() {
    super.initState();
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((timeStamp) async {
      final migrated = await checkMigration();
      if (!migrated && mounted) {
        const MigrationRoute().push(context);
      }
    });
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

  void triggerTextField(WidgetRef ref) {
    if (!showTextField) {
      focusNode.requestFocus();
      setState(() {
        showTextField = true;
      });
    } else {
      setState(() {
        showTextField = false;
      });
      final notifier = ref.read(guardListNotifierProvider.notifier);
      notifier.filterGuards('');
    }
  }
}

class _GuardListTile extends StatefulWidget {
  final Guard guard;

  final void Function()? onTap;
  const _GuardListTile({required this.guard, this.onTap});

  @override
  State<StatefulWidget> createState() => __GuardListTileState();
}

class __GuardListTileState extends State<_GuardListTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surfaceVariant;
    final borderSide = BorderSide(color: surfaceVariant);
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
                  Text(widget.guard.subtitle, style: bodySmall)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
