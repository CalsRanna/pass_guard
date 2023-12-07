import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    this.initialValue,
    this.placeholder,
    this.type = InputType.text,
    this.onChanged,
  });

  final String? initialValue;
  final String? placeholder;
  final InputType type;
  final void Function(String)? onChanged;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  String placeholder = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final outlineVariant = colorScheme.outlineVariant;
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    final bodyMedium = textTheme.bodyMedium;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            placeholder,
            style: bodySmall?.copyWith(color: outlineVariant),
          ),
        ),
        TextFormField(
          initialValue: widget.initialValue,
          cursorHeight: 16,
          decoration: const InputDecoration.collapsed(hintText: null),
          obscureText: widget.type == InputType.password,
          style: bodyMedium,
          onChanged: handleChanged,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    updatePlaceholder(widget.initialValue);
  }

  void updatePlaceholder(String? value) {
    setState(() {
      if (value != null && value.isNotEmpty) {
        placeholder = '';
      } else {
        placeholder = widget.placeholder ?? '';
      }
    });
  }

  void handleChanged(String value) {
    updatePlaceholder(value);
    widget.onChanged?.call(value);
  }
}

enum InputType { password, text }
