import 'package:flutter/material.dart';

class FormItem extends StatelessWidget {
  const FormItem({
    super.key,
    this.bordered = true,
    required this.label,
    this.leading,
    this.labelWidth = 64,
    required this.child,
  });

  final bool bordered;
  final String label;
  final Widget? leading;
  final double labelWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surfaceVariant;
    final borderSide = BorderSide(color: surfaceVariant);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: bordered ? borderSide : BorderSide.none),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: leading ??
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.end,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(child: child)
        ],
      ),
    );
  }
}
