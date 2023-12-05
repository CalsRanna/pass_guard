import 'package:flutter/material.dart';

/// A widget that represents an input field.
///
/// The input field can be used to collect user input.
/// It has properties such as [controller] to control the input value,
/// [placeholder] to display a hint text, and [validator] to validate the input value.
class Input extends StatefulWidget {
  const Input({
    super.key,
    this.controller,
    this.initValue,
    this.placeholder,
    this.type = InputType.text,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? initValue;
  final String? placeholder;
  final InputType type;
  final void Function(String)? onChanged;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  String placeholder = '';

  /// Builds a container with a text form field.
  ///
  /// The container has a border at the bottom with the color specified by the [outline] property in the current [Theme].
  /// It also applies padding to all sides of the container.
  /// The text form field is created with the provided [controller] and [placeholder].
  /// The [validator] function is used to validate the input value.
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
          initialValue: widget.initValue,
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
    updatePlaceholder(widget.initValue);
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
