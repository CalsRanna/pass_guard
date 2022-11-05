import 'package:flutter/material.dart';

class SettingLabel extends StatelessWidget {
  const SettingLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
