import 'package:flutter/material.dart';

class FormGroup extends StatelessWidget {
  const FormGroup({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surfaceVariant;
    final borderSide = BorderSide(color: surfaceVariant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 88, top: 16, bottom: 16),
          child: title != null
              ? Text(title!, style: bodyMedium)
              : const SizedBox(),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(top: borderSide, bottom: borderSide),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(left: 16),
          child: child,
        ),
      ],
    );
  }
}
