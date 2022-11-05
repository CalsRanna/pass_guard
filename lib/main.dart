import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/page/list.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('setting');
  runApp(CreatorGraph(child: const PasswordGenerator()));
}

class PasswordGenerator extends StatelessWidget {
  const PasswordGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PasswordList(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
