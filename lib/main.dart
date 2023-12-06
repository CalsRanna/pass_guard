import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/isar.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('setting');
  await IsarInitializer.ensureInitialized();
  runApp(CreatorGraph(child: const ProviderScope(child: PasswordGenerator())));
}

class PasswordGenerator extends StatelessWidget {
  const PasswordGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
