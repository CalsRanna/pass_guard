import 'package:flutter/material.dart';

/// A widget that creates a form item with an optional leading widget, a label, and a child widget.
///
/// The [FormItem] is designed to be used within a form, providing a consistent layout
/// for form fields. It allows for an optional leading widget, such as an icon or an additional
/// text label, and requires a main label and a child widget, typically a form field like
/// [TextField] or [DropdownButton].
///
/// The [bordered] property adds a bottom border to the form item container when set to true.
/// The width of the label section can be customized by setting the [labelWidth] property.
class FormItem extends StatelessWidget {
  /// Creates a [FormItem] widget.
  ///
  /// This constructor initializes the form item with the given properties.
  /// - [bordered] determines whether the form item has a border at the bottom. Defaults to `true`.
  /// - [label] is the text to display as the main label of the form item.
  /// - [leading] is the optional leading widget placed before the label. It could be an icon or another widget.
  /// - [labelWidth] sets the width of the label section, defaulting to 64 pixels.
  /// - [child] is the main content of the form item, typically a form field.
  ///
  /// The [label] and [child] arguments must not be null.
  const FormItem({
    super.key,
    this.bordered = true,
    required this.label,
    this.leading,
    this.labelWidth = 64,
    required this.child,
  });

  /// Whether the form item has a bottom border.
  ///
  /// When set to true, a border is drawn at the bottom of the form item container.
  /// This is useful for visually separating form items in a list or group.
  ///
  /// Defaults to true, providing a bottom border.
  final bool bordered;

  /// The text that describes the input field in the form item.
  ///
  /// This label is displayed adjacent to the field or input control provided
  /// by the [child] widget. It is used to inform the user about the nature of
  /// the data expected to be entered in the form field.
  final String label;

  /// The widget to display before the [label].
  ///
  /// This can be any widget, but it is typically an icon or an indicator that
  /// provides additional context about the form field. It is displayed at the
  /// start of the form item, aligned with the label and input field.
  ///
  /// If null, no leading widget is shown.
  final Widget? leading;

  /// The width of the label area in the form item.
  ///
  /// Specifies the fixed width for the label that describes the input field.
  /// This width determines the horizontal space that the label occupies,
  /// allowing the form item to align properly within a form.
  ///
  /// Defaults to 64.0 pixels.
  final double labelWidth;

  /// The main content of the form item, typically a form field.
  ///
  /// This widget is displayed next to the [label] and is intended to receive
  /// user input. It could be a [TextField], [DropdownButton], or any other
  /// widget that allows user interaction and data entry.
  ///
  /// The [child] argument must not be null.
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
