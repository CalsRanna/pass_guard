import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:password_generator/page/setting.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/migration.dart';

/// `PasswordList` is a StatefulWidget that is responsible for displaying a list of passwords.
///
/// It uses the `_PasswordListState` to manage its state.
class PasswordList extends StatefulWidget {
  /// Creates a [PasswordList] instance.
  ///
  /// This constructor initializes a new instance of [PasswordList] widget.
  const PasswordList({super.key});

  @override
  State<PasswordList> createState() {
    return _PasswordListState();
  }
}

/// `_PasswordListState` is a private class that extends `State<PasswordList>`.
///
/// It is responsible for managing the state of the `PasswordList` widget.
/// It contains a `FocusNode` and a boolean `showTextField` to manage the input focus and the visibility of a TextField widget respectively.
class _PasswordListState extends State<PasswordList> {
  /// Represents a single interaction with the user interface.
  ///
  /// It keeps track of whether this part of the user interface
  /// currently has the keyboard focus.
  ///
  /// It is used in [_PasswordListState] to manage the input focus.
  FocusNode focusNode = FocusNode();

  /// Indicates whether the TextField widget is visible or not.
  ///
  /// When set to `true`, the TextField widget is visible and when set to `false`, it is hidden.
  /// This property is used to control the visibility of the TextField widget in the UI.
  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    List<Widget>? actions = [
      Consumer(
        builder: (_, ref, child) => IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () => toggleTextField(ref),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: showSetting,
      ),
    ];

    Widget? title;
    if (showTextField) {
      actions = [
        Consumer(
          builder: (_, ref, child) => IconButton(
            onPressed: () => toggleTextField(ref),
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
                itemBuilder: (_, index) => _GuardListTile(
                  guard: value[index],
                  onTap: () => showDetail(value[index].id),
                ),
                itemCount: value.length,
                separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  height: 1,
                ),
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

  /// Initiates the process of creating a new password.
  ///
  /// This method navigates to the CreateGuardRoute, where the user can
  /// generate a new password. The new password is then stored and can be used later.
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

  /// Navigates to the settings page when invoked.
  ///
  /// This method is responsible for pushing the Settings page onto the navigation
  /// stack using a MaterialPageRoute. The Settings page is built using the [Setting] widget.
  void showSetting() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Setting()),
    );
  }

  /// Toggles the visibility of the TextField widget when invoked.
  ///
  /// This method is responsible for switching the visibility of the TextField widget.
  /// If the TextField widget is not visible, this method will request focus for the
  /// TextField widget and set [showTextField] to `true` making it visible.
  /// If the TextField widget is already visible, this method will set [showTextField]
  /// to `false` hiding the TextField widget and trigger the filterGuards method on the
  /// [guardListNotifierProvider] with an empty string to reset the filter.
  ///
  /// [ref] is the WidgetRef from the Riverpod context which is used to read the
  /// [guardListNotifierProvider].
  void toggleTextField(WidgetRef ref) {
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

/// A StatelessWidget that represents a ListTile for a Guard.
///
/// This widget takes a [Guard] object and an optional onTap function as input
/// and builds a ListTile widget. The ListTile displays the title and subtitle
/// of the guard and has an icon leading the text.
///
/// The ListTile also handles onTap events. If a function is provided to the
/// [onTap] parameter, it is called when the ListTile is tapped.
/// If no function is provided, onTap events are ignored.
///
/// The [Guard] object must be provided, but the onTap function is optional.
class _GuardListTile extends StatelessWidget {
  /// Represents a [Guard] object associated with this widget.
  ///
  /// The [Guard] object contains various properties that define the characteristics
  /// of the guard in the context of this list tile. These properties can include
  /// things like the guard's title, subtitle, and whether it is currently active.
  final Guard guard;

  /// A callback that is called when the [_GuardListTile] widget is tapped.
  ///
  /// This function will be invoked when the user taps on the [_GuardListTile] widget.
  /// It can be used to execute any additional logic when the widget is activated by the user.
  ///
  /// This function is optional, if it's not provided, onTap events are ignored.
  final void Function()? onTap;

  /// Constructs a [_GuardListTile] instance.
  ///
  /// Takes a [Guard] object and an optional onTap function as parameters.
  /// - [guard] - Represents a [Guard] object associated with this widget.
  /// - [onTap] - A callback function that is invoked when the [_GuardListTile] widget is tapped.
  ///   If it's not provided, onTap events are ignored.
  const _GuardListTile({required this.guard, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        guard.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        guard.subtitle,
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
      onTap: onTap,
    );
  }
}
