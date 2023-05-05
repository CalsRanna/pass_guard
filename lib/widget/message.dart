import 'package:flutter/material.dart';

class Message {
  final BuildContext context;
  Message.of(this.context);

  void show(String message, {Duration? duration}) {
    final color = Theme.of(context).colorScheme.primary;
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }
}
