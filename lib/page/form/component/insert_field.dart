import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/widget/form_group.dart';
import 'package:password_generator/widget/form_item.dart';
import 'package:password_generator/widget/input.dart';

/// The [InsertFieldPage] is a StatefulWidget that provides a form interface for inserting a field.
///
/// This page allows users to input a label and select a type for a new form field.
/// The state for this widget, [_InsertFieldPageState], manages the input data and
/// potentially other form-related logic.
class InsertFieldPage extends StatefulWidget {
  /// Creates an instance of [InsertFieldPage].
  ///
  /// This constructor is the default for [InsertFieldPage] and takes an optional
  /// [Key] as its argument which initializes the [key] property of [StatefulWidget].
  const InsertFieldPage({super.key});

  @override
  State<InsertFieldPage> createState() => _InsertFieldPageState();
}

/// State for [InsertFieldPage].
///
/// This state handles the logic for inserting a new field into a form. It manages
/// the input for the field's label and type and provides methods for handling form
/// submission and cancellation.
///
/// The [label] field stores the current input for the field's label, while the
/// [type] field stores the selected type of the field. These are used when the
/// form is submitted to create a new form field.
class _InsertFieldPageState extends State<InsertFieldPage> {
  /// The text label for the form field.
  ///
  /// This variable holds the label text that is associated with the input field.
  /// It is displayed as a part of the form item and is used for identifying
  /// the purpose of the field to the user.
  String label = '';

  /// The type of the form field.
  ///
  /// This variable holds the type of the input field which can be used
  /// to determine the kind of widget to display for data input.
  /// For example, 'text' indicates a plain text input field.
  String type = 'text';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: label.isNotEmpty ? handleSubmit : null,
            child: const Text('完成'),
          )
        ],
        leading: TextButton(
          onPressed: handlePop,
          child: const Text('取消'),
        ),
        title: const Text('添加小节'),
      ),
      body: ListView(
        children: [
          FormGroup(
            child: Column(
              children: [
                FormItem(
                  label: '名称',
                  child: Input(
                    initialValue: label,
                    onChanged: (value) {
                      setState(() {
                        label = value;
                      });
                    },
                  ),
                ),
                FormItem(
                  label: '类型',
                  child: Input(
                    initialValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Submits the form field data.
  ///
  /// This function creates a [Field] instance, sets its [label] and [type]
  /// properties from the state, and then uses [GoRouter] to pop the current
  /// route off the stack, returning the newly created [Field] to the previous
  /// screen.
  void handleSubmit() {
    final field = Field();
    field.label = label;
    field.type = type;
    GoRouter.of(context).pop(field);
  }

  /// Pops the current route off the [GoRouter] stack.
  ///
  /// This method is used to dismiss the current screen and return to the
  /// previous one. It is typically called in response to a user's action,
  /// such as pressing a 'Cancel' button.
  void handlePop() {
    GoRouter.of(context).pop();
  }
}
