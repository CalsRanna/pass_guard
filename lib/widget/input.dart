import 'package:flutter/material.dart';

/// `Input` is a StatefulWidget that provides a text input field.
///
/// It takes an optional initial value, a placeholder, and an onChanged function.
/// It also accepts an InputType to specify the type of the input field.
///
/// The `Input` widget is used to receive user input in form fields throughout the application.
class Input extends StatefulWidget {
  /// The initial value of the input field.
  ///
  /// This value is used to pre-fill the input field when it is first displayed. If
  /// no initial value is provided, the input field will be empty. It is optional.
  final String? initialValue;

  /// The placeholder text for the input field.
  ///
  /// This value is displayed inside the input field before the user enters a value.
  /// It provides a hint to the user about what kind of input is expected in the field.
  /// It is optional and if not provided, the input field will not have a placeholder.
  final String? placeholder;

  /// The type of input field.
  ///
  /// This enum is used to specify the type of the input field in the `Input` widget.
  /// It can be either `text` or `password`. For `text`, the input field accepts any text input.
  /// For `password`, the input field obscures the text input, suitable for password input fields.
  final InputType type;

  /// Called when the user changes the input in the field.
  ///
  /// This callback is invoked with the updated text input whenever the user
  /// types into the field or otherwise modifies the input in the field.
  /// It can be used to update the state or perform other side effects in response
  /// to the user's input.
  final void Function(String)? onChanged;

  /// Creates an instance of [Input].
  ///
  /// This constructor takes an optional initial value, a placeholder, an onChanged function
  /// and an input type.
  ///
  /// The [initialValue] parameter is the initial value of the input field.
  /// [placeholder] is the placeholder text for the input field.
  /// [type] is used to specify the type of the input field. It can be either `text` or `password`.
  /// [onChanged] is a callback that is invoked when the user changes the input in the field.
  const Input({
    super.key,
    this.initialValue,
    this.placeholder,
    this.type = InputType.text,
    this.onChanged,
  });

  @override
  State<Input> createState() => _InputState();
}

/// [_InputState] is a State object for the [Input] widget.
///
/// This class manages the state for the [Input] widget, including the text
/// that the user has entered into the field, whether the text should be
/// obscured (for password fields), and the current placeholder text.
///
/// It uses a [TextEditingController] to control the text input and provide
/// updates when the text changes.
class _InputState extends State<Input> {
  /// The [controller] is a [TextEditingController] that controls the text being edited.
  ///
  /// It provides the ability to read and write the current text in the [Input] field,
  /// and to listen for changes to the text value. It is used to control the text
  /// being edited and to handle user interactions with the [Input] field.
  TextEditingController controller = TextEditingController();

  /// Determines whether the text in the input field is obscured.
  ///
  /// If set to `true`, the text in the input field is obscured, typically for password inputs.
  /// If `false`, the text is displayed as entered.
  /// By default, this is set to `true`.
  bool obscure = true;

  /// The placeholder text to be displayed in the [Input] field when it is empty.
  ///
  /// The placeholder provides a short hint that describes the expected value of the input field.
  /// It gets displayed in the [Input] field before the user enters a value.
  /// It disappears when the user starts typing.
  String placeholder = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final surfaceVariant = colorScheme.surfaceVariant;
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    final bodyMedium = textTheme.bodyMedium;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            placeholder,
            style: bodySmall?.copyWith(color: surfaceVariant),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                cursorHeight: 16,
                decoration: const InputDecoration.collapsed(hintText: null),
                obscureText: widget.type == InputType.password && obscure,
                style: bodyMedium,
                onChanged: handleChanged,
              ),
            ),
            if (widget.type == InputType.password)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: changeObscure,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 20,
                  child: Icon(
                    color: primary,
                    obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 16,
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }

  /// Toggles the visibility of the text in the TextField.
  ///
  /// If the text is currently obscured, it will become visible, and vice versa.
  void changeObscure() {
    setState(() {
      obscure = !obscure;
    });
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    // controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Handles the change event for the TextField.
  ///
  /// This method is called whenever the text in the TextField changes.
  /// It accepts the updated text value as an argument and does the following:
  /// 1. Calls the `updatePlaceholder` method with the new value to update the placeholder.
  /// 2. Invokes the optional `onChanged` callback of the widget, if provided, with the new value.
  ///
  /// [value] The new text value for the TextField.
  void handleChanged(String value) {
    updatePlaceholder(value);
    widget.onChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue ?? '';
    updatePlaceholder(widget.initialValue);
  }

  /// Updates the placeholder text for the input field based on the given value.
  ///
  /// If the provided value is not null and not empty, the placeholder text is cleared.
  /// Otherwise, the placeholder text is set to the widget's placeholder value or an empty string if none is provided.
  ///
  /// [value] The new text value for the TextField.
  void updatePlaceholder(String? value) {
    setState(() {
      if (value != null && value.isNotEmpty) {
        placeholder = '';
      } else {
        placeholder = widget.placeholder ?? '';
      }
    });
  }
}

/// Enum representing the type of an input field in a form.
///
/// - [InputType.password]: Represents a password input field. The text entered into this field is hidden.
/// - [InputType.text]: Represents a text input field. The text entered into this field is visible.
enum InputType { password, text }
