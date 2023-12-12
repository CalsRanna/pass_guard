import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/widget/form_group.dart';
import 'package:password_generator/widget/form_item.dart';
import 'package:password_generator/widget/input.dart';

/// The [InsertSegmentPage] widget allows users to insert segments into a form.
///
/// It provides an interface for naming a segment and potentially other segment-related configurations.
/// After the segment details are specified, they can be submitted to create a new form segment.
class InsertSegmentPage extends StatefulWidget {
  /// Creates an instance of [InsertSegmentPage].
  ///
  /// This constructor initializes the [InsertSegmentPage] with an optional [Key] parameter.
  const InsertSegmentPage({super.key});

  @override
  State<InsertSegmentPage> createState() => _InsertSegmentPageState();
}

/// State class for [InsertSegmentPage].
///
/// This class holds the state for the [InsertSegmentPage], managing the user input
/// for naming a segment. It provides methods for handling the submission and cancellation
/// of the form, which interacts with the navigation stack through [GoRouter].
class _InsertSegmentPageState extends State<InsertSegmentPage> {
  /// The [name] string holds the current value entered by the user for the segment's name.
  ///
  /// It is used to enable or disable the submit button in the UI depending on whether
  /// a name has been entered, as well as to pass the segment name back to the previous
  /// screen upon successful submission.
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: name.isNotEmpty ? handleSubmit : null,
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
            child: FormItem(
              label: '名称',
              child: Input(
                initialValue: name,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Submits the segment with the current name.
  ///
  /// This method is called when the '完成' button is pressed.
  /// If a name has been entered, it uses [GoRouter] to pop the current
  /// route off the stack and passes the segment name back to the previous screen.
  void handleSubmit() {
    GoRouter.of(context).pop(name);
  }

  /// Pops the current route off the stack using [GoRouter].
  ///
  /// This method is called when the '取消' button is pressed. It is used
  /// to dismiss the insert segment screen and return to the previous screen,
  /// without passing any data back.
  void handlePop() {
    GoRouter.of(context).pop();
  }
}
