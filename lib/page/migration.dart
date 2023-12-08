import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/schema/migration.dart';
import 'package:password_generator/state/global.dart';

class MigrationPage extends StatefulWidget {
  const MigrationPage({super.key});

  @override
  State<MigrationPage> createState() => _MigrationPageState();
}

class _MigrationPageState extends State<MigrationPage> {
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

  void getAllPasswords() async {
    final database = await context.ref.read(databaseEmitter);
    final passwords = await database.passwordDao.getAllPasswords();
    setState(() {
      count = passwords.length;
    });
  }

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
