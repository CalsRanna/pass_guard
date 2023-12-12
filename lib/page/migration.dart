import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/migration.dart';
import 'package:password_generator/state/global.dart';

/// A StatefulWidget that handles the migration process within the app.
///
/// Displays a page that allows users to initiate and manage database migrations.
/// This is typically used when the app's data schema has been updated and
/// existing data needs to be migrated to the new schema version.
class MigrationPage extends StatefulWidget {
  /// Creates an instance of [MigrationPage].
  ///
  /// This constructor is used to create a new MigrationPage widget
  /// that handles the migration process within the app.
  const MigrationPage({super.key});

  @override
  State<MigrationPage> createState() => _MigrationPageState();
}

/// Represents the state for [MigrationPage].
///
/// This state is responsible for handling the migration process of the app's
/// local database. It provides a visual guide and interactive elements to
/// assist the user in migrating their data to the latest database schema.
class _MigrationPageState extends State<MigrationPage> {
  /// The current number of migrations that have been processed.
  ///
  /// This counter is incremented as each migration is successfully completed.
  /// It is used to track the progress of the migration process and provide
  /// feedback to the user.
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onPrimary = colorScheme.onPrimary;
    final textTheme = theme.textTheme;
    final displaySmall = textTheme.displaySmall;
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '新版本采用了全新的本地存储方案，现在需要将所有密码迁移到新版本',
              style: displaySmall?.copyWith(
                color: onPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Consumer(
              builder: (_, ref, child) => ElevatedButton(
                onPressed: () => migrate(ref),
                child: const Text('开始迁移'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((timeStamp) {
      getAllPasswords();
    });
  }

  /// Retrieves all passwords from the database and updates the state with the count.
  ///
  /// This function makes a call to the database to fetch all the passwords,
  /// then it sets the state with the total number of passwords retrieved.
  void getAllPasswords() async {
    final database = await context.ref.read(databaseEmitter);
    final passwords = await database.passwordDao.getAllPasswords();
    setState(() {
      count = passwords.length;
    });
  }

  /// Initiates the migration of passwords to a new storage system.
  ///
  /// This asynchronous function retrieves all passwords from the old database,
  /// creates a corresponding new data structure for each, then saves them
  /// into the new database using Isar. After migration, it updates the
  /// migration status and navigates back to the previous screen.
  ///
  /// The function takes a [WidgetRef] parameter, which is used to read from
  /// and write to the state and to interact with the database through providers.
  ///
  /// [ref] The WidgetRef used for interacting with providers.
  void migrate(WidgetRef ref) async {
    final database = await context.ref.read(databaseEmitter);
    final passwords = await database.passwordDao.getAllPasswords();
    for (final password in passwords) {
      final guard = Guard();
      guard.title = password.name;
      final authenticationSegment = Segment();
      final usernameField = Field();
      usernameField.key = 'username';
      usernameField.value = password.username;
      usernameField.type = 'text';
      usernameField.label = '用户名';
      final passwordField = Field();
      passwordField.key = 'password';
      passwordField.value = password.password;
      passwordField.type = 'password';
      passwordField.label = '密码';
      authenticationSegment.fields = [usernameField, passwordField];
      final commentSegment = Segment();
      commentSegment.title = '备注';
      final commentField = Field();
      commentField.key = 'comment';
      commentField.value = password.comment ?? '';
      commentField.type = 'text';
      commentField.label = '备注';
      commentSegment.fields = [commentField];
      guard.segments = [authenticationSegment, commentSegment];
      await isar.writeTxn(() async {
        await isar.guards.put(guard);
      });
    }
    final migration = Migration();
    migration.name = 'floor_to_isar';
    await isar.writeTxn(() async {
      await isar.migrations.put(migration);
    });
    ref.invalidate(guardListNotifierProvider);
    if (mounted) {
      GoRouter.of(context).pop();
    }
  }
}
