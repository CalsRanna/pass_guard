import 'package:flutter/material.dart';

class Message {
  final BuildContext context;
  Message.of(this.context);

  void show(String message, {Duration? duration}) {
    final color = Theme.of(context).colorScheme.primary;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: duration ?? const Duration(seconds: 1),
        margin: const EdgeInsets.fromLTRB(16, 5, 16, 10),
        shape: const StadiumBorder(),
      ),
    );
  }
}
