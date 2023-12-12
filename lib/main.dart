import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/isar.dart';

/// Initializes the application by setting up Hive and Isar, and then runs the app.
///
/// This includes initializing Hive for local storage, opening a settings box,
/// ensuring Isar database is initialized, and finally running the app within
/// a CreatorGraph and ProviderScope for state management.
void main() async {
  await Hive.initFlutter();
  await Hive.openBox('setting');
  await IsarInitializer.ensureInitialized();
  runApp(CreatorGraph(child: const ProviderScope(child: PasswordGenerator())));
}

/// A stateless widget that creates a Material App configured with a router.
///
/// This widget sets up the main structure of the app with routing capabilities
/// provided by the `router` object. It should be used at the root of the widget
/// tree to enable navigation throughout the app.
class PasswordGenerator extends StatelessWidget {
  const PasswordGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
