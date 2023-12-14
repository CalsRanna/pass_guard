import 'package:flutter/material.dart';

/// A custom form group widget that wraps a [title] and a [child] widget.
///
/// This widget is designed to group form fields with an optional title heading.
/// It takes a [title], which can be null, and a required [child] widget.
/// The [child] is typically a form field or a collection of form fields.
///
/// The appearance is stylized according to the current theme's color scheme,
/// with borders on the top and bottom of the [child] widget.
class FormGroup extends StatelessWidget {
  /// Creates a [FormGroup] widget that displays a form section with an optional title.
  ///
  /// The constructor takes an optional [title] parameter which can be null
  /// and a required [child] widget parameter. The [child] parameter is typically
  /// used to pass form field widgets or a group of form field widgets that
  /// will be part of the form group.
  ///
  /// The provided [child] widget is wrapped with a styled [Container] that has
  /// borders on the top and bottom. The appearance is consistent with the current
  /// theme's color scheme.
  const FormGroup({super.key, this.title, required this.child});

  /// The optional title for the form group.
  ///
  /// If a non-null value is provided, it is displayed above the [child] widget
  /// as a heading for the form section. This is useful for categorizing form
  /// fields into different sections for better organization and readability.
  ///
  /// If the title is null, no heading is displayed and the [child] is rendered
  /// without a title.
  final String? title;

  /// The widget below this heading in the form group.
  ///
  /// This required widget is typically a form field or a collection of form fields.
  /// It is wrapped inside a styled [Container] with a top and bottom border.
  /// The entire [FormGroup] is styled according to the theme's color scheme.
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
