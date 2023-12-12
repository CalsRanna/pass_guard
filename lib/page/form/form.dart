import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/guard_template.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/util/password_generator.dart';
import 'package:password_generator/widget/form_group.dart';
import 'package:password_generator/widget/form_item.dart';
import 'package:password_generator/widget/input.dart';

/// The `PasswordForm` is a stateful widget that provides a form interface for creating or editing a password.
///
/// This form allows users to input details for a password entity which can then be saved to persistent storage.
/// It can be initialized with an optional `id` and `template` which, if provided, can be used to pre-populate
/// the form fields with existing data for editing.
///
/// [id] is an optional parameter that can be used to identify an existing password item for editing.
/// [template] is an optional parameter that can be used to initialize the form with predefined values.
class PasswordForm extends StatefulWidget {
  /// Creates a [PasswordForm] widget for creating or editing password entries.
  ///
  /// This constructor initializes the [PasswordForm] with an optional [id] and a [template].
  /// If [id] is provided, the form is pre-populated with the existing data for that entry,
  /// allowing for easy editing. The [template] can be used to set predefined values
  /// when creating a new password entry.
  ///
  /// [id] is the identifier of an existing password entry to be edited.
  /// [template] is a predefined template used to pre-populate form fields.
  const PasswordForm({super.key, this.id, this.template});

  /// The identifier of an existing password entry to be edited.
  ///
  /// This field holds the id of a password entry. It is used when the form
  /// is in edit mode to pre-populate the form fields with the existing data
  /// for that entry. If null, the form will be in create mode, allowing the
  /// user to input new password details.
  final int? id;

  /// The predefined template for initializing form fields.
  ///
  /// This field holds a template value that can be used when creating a new password entry.
  /// It provides predefined values to the form fields, making the data entry process
  /// faster and more consistent. If null, the form fields will remain empty and will
  /// require manual input by the user.
  final String? template;

  @override
  State<PasswordForm> createState() {
    return _PasswordFormState();
  }
}

/// State for [PasswordForm] widget.
///
/// This state manages the visibility of the password (obscure text),
/// the display of the password generator, and the current state of the
/// password entry (guard).
///
/// It initializes the guard based on the provided [PasswordForm.id]
/// and [PasswordForm.template] if they are not null, otherwise,
/// it initializes a new password entry for creation.
class _PasswordFormState extends State<PasswordForm> {
  /// Determines if the text in the password field should be obscured.
  ///
  /// When set to `true`, the text in the password field will be replaced
  /// with dots to hide the actual characters. This is typically used to
  /// maintain the confidentiality of the password input. When set to `false`,
  /// the password will be displayed plainly, which could be used for
  /// situations where the user needs to confirm the input password.
  bool obscureText = true;

  /// Indicates whether the password generator is currently shown.
  ///
  /// When set to `true`, the password generator interface will be displayed,
  /// allowing the user to create a new password based on specified criteria.
  /// When set to `false`, the password generator will be hidden.
  bool showGenerator = false;

  /// The [Guard] object that holds the details of the password entry.
  ///
  /// This property is used to store and manage the information of an individual
  /// password entry such as the title, username, password, and any additional
  /// comments or metadata. It can be initialized with default values if a
  /// [template] is provided, or it can start with empty values for manual entry.
  var guard = Guard();

  @override
  void initState() {
    super.initState();
    initGuard();
    findGuard();
  }

  /// Initializes the [Guard] object based on the provided template.
  ///
  /// If [PasswordForm.template] is not null, this method retrieves a
  /// guard template with the matching name from the database using
  /// [isar.guardTemplates], converts it to a [Guard] object via
  /// [Guard.fromJson], and updates the [guard] state. If the template
  /// is not found or the [template] is null, the method simply returns
  /// and no action is taken.
  ///
  /// This function is called during the [initState] lifecycle to
  /// pre-populate the form when editing an existing password entry.
  void initGuard() async {
    if (widget.template == null) return;
    final template = await isar.guardTemplates
        .filter()
        .nameEqualTo(widget.template!)
        .findFirst();
    if (template == null) return;
    setState(() {
      guard = Guard.fromJson(template.toJson());
    });
  }

  /// Retrieves the [Guard] object with the given id from the database.
  ///
  /// If [widget.id] is not null, this method fetches the guard with the
  /// corresponding id from the database using [isar.guards.get]. If a guard
  /// with the specified id is found, it updates the [guard] state with the
  /// retrieved object. Otherwise, if no guard is found or [widget.id] is null,
  /// the method simply returns and no action is taken.
  ///
  /// This function is called during the [initState] lifecycle to populate the form
  /// with the details of an existing password entry when editing.
  void findGuard() async {
    if (widget.id == null) return;
    final guard = await isar.guards.get(widget.id!);
    if (guard == null) return;
    setState(() {
      this.guard = guard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(builder: (context, ref, child) {
            final disabled = guard.title.isEmpty;
            return TextButton(
              onPressed: disabled ? null : () => handleConfirm(ref),
              child: const Text('存储'),
            );
          })
        ],
        leading: TextButton(
          onPressed: handlePop,
          child: const Text('取消'),
        ),
        title: Text(widget.id == null ? '添加' : '修改'),
      ),
      body: ListView(
        children: [
          FormGroup(
            key: ValueKey(guard),
            child: FormItem(
              bordered: false,
              label: '标题',
              child: Input(
                initialValue: guard.title,
                placeholder: '添加标题',
                onChanged: (value) {
                  setState(() {
                    guard.title = value;
                  });
                },
              ),
            ),
          ),
          for (final segment in guard.segments)
            FormGroup(
              title: segment.title,
              child: Column(
                children: [
                  for (final field in segment.fields)
                    Column(children: [
                      FormItem(
                        label: field.label,
                        child: Input(
                          initialValue: field.value,
                          type: field.type == 'password'
                              ? InputType.password
                              : InputType.text,
                          onChanged: (value) {
                            setState(() {
                              field.value = value;
                            });
                          },
                        ),
                      ),
                      if (field.type == 'password')
                        _GeneratePassword(
                          label: '生成密码',
                          onTap: () => handleGeneratePassword(field),
                        ),
                    ]),
                  _InsertAction(
                    label: '添加字段',
                    onTap: () => handleInsertField(segment),
                  ),
                ],
              ),
            ),
          FormGroup(
            child: _InsertAction(
              label: '添加小节',
              onTap: handleInsertSegment,
            ),
          ),
        ],
      ),
    );
  }

  /// Generates a password using `PasswordGenerator` and assigns it to the given [field].
  ///
  /// The password will include numbers and special characters and will have a length of 16 characters.
  /// This method updates the state to reflect the new password value for the [field].
  ///
  /// [field] The `Field` object whose `value` will be updated with the generated password.
  void handleGeneratePassword(Field field) async {
    setState(() {
      final password = PasswordGenerator(
        hasNumber: true,
        hasSpecialCharacter: true,
        length: 16.toInt(),
      ).generate();
      setState(() {
        field.value = password;
      });
    });
  }

  /// Inserts a new field into the specified [segment].
  ///
  /// Opens an insert field page where the user can enter the details for the new field. If
  /// the user confirms the insertion, the new field is added to the [segment]'s list of fields and
  /// the state is updated to include the new field.
  ///
  /// [segment] The `Segment` object to which the new field will be added.
  void handleInsertField(Segment segment) async {
    final field = await const InsertFieldPageRoute().push(context);
    if (field != null) {
      setState(() {
        segment.fields = [...segment.fields, field];
      });
    }
  }

  /// Inserts a new segment with the provided name into the current guard.
  ///
  /// This method displays the `InsertSegmentPage` where the user can enter the name for the new segment.
  /// If the user confirms the insertion, a new `Segment` object is created with the given name,
  /// and it is added to the guard's list of segments. The state is updated to reflect the
  /// addition of the new segment.
  ///
  /// If the user cancels the insertion, no changes are made.
  void handleInsertSegment() async {
    final name = await const InsertSegmentPageRoute().push(context);
    if (name != null) {
      setState(() {
        final segment = Segment();
        segment.title = name;
        guard.segments = [...guard.segments, segment];
      });
    }
  }

  /// Toggles the visibility of password input fields.
  ///
  /// When called, this method updates the state of the password fields to either
  /// show or hide the password. This is typically used to control the obscureText
  /// property of text fields where passwords are entered, allowing the user to toggle
  /// between viewing the entered text or hiding it behind obscuration characters.
  void switchObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  /// Confirms the current state and saves the guard.
  ///
  /// This method is triggered when the user presses the confirm button.
  /// It calls the `putGuard` method on the `guardListNotifierProvider` notifier
  /// to save the current `guard` state. After successfully saving the guard,
  /// it navigates back to the previous screen if the current state is still mounted.
  void handleConfirm(WidgetRef ref) async {
    final notifier = ref.read(guardListNotifierProvider.notifier);
    notifier.putGuard(guard);
    if (mounted) {
      GoRouter.of(context).pop();
    }
  }

  /// Pops the current route off the navigator stack.
  ///
  /// This method is used to dismiss the current screen and return to the
  /// previous one. It is typically called in response to a user's action,
  /// such as pressing a 'Cancel' button.
  void handlePop() {
    Navigator.of(context).pop();
  }
}

/// A widget that manages the generation and display of passwords.
///
/// This stateful widget provides the functionality to generate passwords
/// based on certain criteria and allows the user to interact with the
/// password generation process. It takes in an initial password, a flag
/// that controls the visibility of the generator UI, and an optional callback
/// to be invoked when a new password is generated.
///
/// The widget is responsible for rendering the UI elements related to
/// password generation and handling the state changes that occur when
/// the user interacts with the generator.
class _PasswordGenerator extends StatefulWidget {
  /// Creates a [_PasswordGenerator] widget.
  ///
  /// This constructor requires a [password] to be provided which
  /// will be used as the initial password. The [showGenerator] flag
  /// determines whether the password generator UI should be shown.
  /// An optional [onGenerated] callback can be provided which will
  /// be called with the newly generated password.
  const _PasswordGenerator({
    required this.password,
    required this.showGenerator,
    this.onGenerated,
  });

  /// The password that will be used or generated by the [_PasswordGenerator].
  ///
  /// This is the initial password value that is passed into the [_PasswordGenerator]
  /// upon creation. If the user opts to generate a new password, this value will
  /// be replaced with the newly generated password. The generated password will
  /// adhere to any constraints specified by the user, such as the inclusion of
  /// numbers or special characters, and the desired length.
  final String password;

  /// Determines whether the password generator UI is visible to the user.
  ///
  /// When set to `true`, the user interface for generating a new password is displayed,
  /// allowing the user to create a password that meets specific criteria, such as length,
  /// inclusion of numbers, and special characters. When set to `false`, the password
  /// generator UI is hidden, and the password field shows the initial or currently set
  /// password.
  final bool showGenerator;

  /// Callback that is invoked when a new password is generated.
  ///
  /// This function is called with the newly generated password as the
  /// argument. It allows for further processing or handling of the password
  /// once the generation is complete.
  ///
  /// The callback is optional and only invoked if provided.
  final void Function(String)? onGenerated;

  @override
  State<_PasswordGenerator> createState() => __PasswordGeneratorState();
}

/// State management for [_PasswordGenerator] widget.
///
/// This class handles the state of the [_PasswordGenerator] widget, including
/// the presence of numbers and special characters in the generated password,
/// the length of the password, and whether the password is visible or obscured.
/// It also manages the visibility of the password generator UI and holds the
/// [Guard] object containing the details of the password entry.
class __PasswordGeneratorState extends State<_PasswordGenerator> {
  /// Determines if the generated password should include numbers.
  ///
  /// When set to `true`, at least one number will be included in the newly
  /// generated password. This is part of the password complexity requirement
  /// that can be configured by the user. If set to `false`, the generated
  /// password will not contain any numeric characters.
  bool hasNumber = true;

  /// Indicates whether the generated password will include special characters.
  ///
  /// When set to `true`, the generated password will contain at least one special
  /// character from the set of allowed special characters, enhancing password security.
  /// If set to `false`, the password will not contain any special characters.
  bool hasSpecialCharacter = true;

  /// The desired length of the generated password.
  ///
  /// This value determines how many characters the password will contain.
  /// It is set to a default of 16 but can be adjusted by the user to
  /// increase or decrease the complexity of the generated password.
  double length = 16;

  /// Determines whether the password is currently visible to the user.
  ///
  /// When set to `true`, the password will be displayed in plain text,
  /// allowing the user to see the input. This can be useful for
  /// confirming the entered password. When set to `false`, the
  /// password will be obscured, enhancing privacy and security.
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();
    if (widget.showGenerator) {
      child = Card(
        color: Theme.of(context).colorScheme.surfaceVariant,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(widget.password)),
                    IconButton(
                      icon: const Icon(Icons.refresh_outlined),
                      onPressed: handleButtonPressed,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(width: 96, child: Text('${length.toInt()}位密码')),
                  Expanded(
                    child: Slider.adaptive(
                      divisions: 52,
                      min: 8,
                      max: 64,
                      value: length,
                      onChanged: handleSliderChanged,
                      onChangeEnd: handleSliderChangeEnd,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('特殊符号'),
                  const Expanded(child: SizedBox()),
                  Switch.adaptive(
                    value: hasSpecialCharacter,
                    onChanged: handleSpecialCharacterSwitchChanged,
                  )
                ],
              ),
              Row(
                children: [
                  const Text('数字'),
                  const Expanded(child: SizedBox()),
                  Switch.adaptive(
                    value: hasNumber,
                    onChanged: handleNumberSwitchChanged,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }

  /// Toggles the visibility of a password.
  ///
  /// When this method is called, it updates the state to either show or hide
  /// the password by changing the value of `showPassword`. This function is
  /// typically used in conjunction with password input fields where the user
  /// might want to toggle the visibility of the password they have entered.
  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  /// Handles the event when the button is pressed.
  ///
  /// This method is triggered when the user presses the button to generate a new password.
  /// It uses the current state of `hasNumber`, `hasSpecialCharacter`, and `length`
  /// to create a password with the `PasswordGenerator`. Once the password is generated,
  /// it is passed to the `onGenerated` callback of the widget, if it's available.
  void handleButtonPressed() {
    final password = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
      length: length.toInt(),
    ).generate();
    widget.onGenerated?.call(password);
  }

  /// Updates the slider value when the user changes the slider position.
  ///
  /// This method is called when the user is selecting a new password length using
  /// the slider. It updates the state with the new slider value, which is then
  /// used for generating the password length.
  ///
  /// [value] is the new value of the slider.
  void handleSliderChanged(double value) {
    setState(() {
      length = value;
    });
  }

  /// Handles the event when slider interaction is complete.
  ///
  /// This method is triggered when the user completes the slider movement,
  /// selecting a new password length. It generates a new password based on the
  /// updated length and other criteria such as `hasNumber` and `hasSpecialCharacter`.
  /// The new password is then passed to the `onGenerated` callback of the widget.
  ///
  /// [value] is the final value of the slider after user interaction is complete.
  void handleSliderChangeEnd(double value) {
    final password = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
      length: value.toInt(),
    ).generate();
    widget.onGenerated?.call(password);
  }

  /// Updates the state to reflect whether special characters should be included in the password.
  ///
  /// This method is called when the user toggles the switch for including special characters in the password.
  /// It generates a new password with the updated `hasSpecialCharacter` setting, updates the state,
  /// and invokes the `onGenerated` callback with the new password.
  ///
  /// [value] indicates whether special characters should be included (`true`) or not (`false`).
  void handleSpecialCharacterSwitchChanged(bool value) {
    final password = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: value,
      length: length.toInt(),
    ).generate();
    setState(() {
      hasSpecialCharacter = value;
    });
    widget.onGenerated?.call(password);
  }

  /// Updates the state to reflect whether numbers should be included in the password.
  ///
  /// This method is called when the user toggles the switch for including numbers in the password.
  /// It generates a new password with the updated `hasNumber` setting, updates the state,
  /// and invokes the `onGenerated` callback with the new password.
  ///
  /// [value] indicates whether numbers should be included (`true`) or not (`false`).
  void handleNumberSwitchChanged(bool value) {
    final password = PasswordGenerator(
      hasNumber: value,
      hasSpecialCharacter: hasSpecialCharacter,
      length: length.toInt(),
    ).generate();
    setState(() {
      hasNumber = value;
    });
    widget.onGenerated?.call(password);
  }
}

/// A StatefulWidget that provides an interface for generating a password.
///
/// This widget displays a label and triggers password generation when tapped.
/// It is designed to be used within forms or settings where a user can manually
/// initiate the creation of a new password.
///
/// The [label] is displayed as the text of the widget.
/// The [onTap] callback is called when the user taps the widget.
class _GeneratePassword extends StatefulWidget {
  /// Creates a [_GeneratePassword] widget.
  ///
  /// This constructor requires a [label] to be provided which will be displayed
  /// as the text of the widget. An optional [onTap] callback can be provided
  /// which will be called when the user taps the widget.
  ///
  /// The widget is designed to be used within forms or settings where a user can
  /// manually initiate the creation of a new password.
  ///
  /// [label] is the text that will be displayed on the widget.
  /// [onTap] is the callback that is called when the widget is tapped.
  const _GeneratePassword({required this.label, this.onTap});

  /// The text that will be displayed on the [_GeneratePassword] widget.
  ///
  /// This label provides context to the user, indicating the purpose of the widget,
  /// which is to generate a new password when tapped.
  final String label;

  /// Callback that is called when the widget is tapped.
  ///
  /// This function will be invoked when the user taps on the [_GeneratePassword] widget.
  /// It can be used to execute any additional logic when the widget is activated by the user.
  final void Function()? onTap;

  @override
  State<_GeneratePassword> createState() => __GeneratePasswordState();
}

/// State class for [_GeneratePassword] widget.
///
/// This class manages the state for the [_GeneratePassword] widget which includes
/// user interactions and UI updates. It is responsible for building the UI of the
/// widget with the appropriate styling and behavior, such as reacting to user taps.
class __GeneratePasswordState extends State<_GeneratePassword> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: FormItem(
        label: '',
        leading: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Icon(Icons.pin, color: Colors.white, size: 16),
          ),
        ),
        child: Text(widget.label, style: bodySmall),
      ),
    );
  }
}

/// A StatefulWidget that creates an insert field.
///
/// This widget provides an interface for inserting a new field. It displays a label
/// and triggers an optional onTap callback when the field is interacted with.
class _InsertField extends StatefulWidget {
  /// Creates an [_InsertField] widget.
  ///
  /// This constructor requires a [label] to display next to the field and an
  /// optional [onTap] callback which is called when the field is tapped.
  ///
  /// The [label] argument must not be null.
  const _InsertField({required this.label, this.onTap});

  /// The text label displayed next to the insert field.
  ///
  /// This label provides context to the user, indicating the purpose or
  /// content of the field that will be inserted. It is displayed adjacent
  /// to the field and is essential for accessibility and user guidance.
  final String label;

  /// Called when the insert field is tapped.
  ///
  /// This callback is invoked when the user performs a tap gesture on the insert field.
  /// It can be used to execute any additional logic when the field is interacted with,
  /// such as opening a dialog or updating a value.
  final void Function()? onTap;

  @override
  State<_InsertField> createState() => __InsertFieldState();
}

/// The state class for the [_InsertField] widget.
///
/// This class manages the state and builds the UI for the [_InsertField] widget.
/// It provides a gesture detector to handle taps and constructs a form item
/// with a leading green circle icon and the label text passed from the widget.
class __InsertFieldState extends State<_InsertField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: FormItem(
        label: '',
        leading: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ),
        child: Text(widget.label, style: bodySmall),
      ),
    );
  }
}

/// A StatefulWidget that manages the state for an insert action.
///
/// This widget is designed to represent an interactive element in the UI
/// that triggers an action when tapped. It displays a label that describes
/// the action and can execute a callback function provided via the onTap parameter.
class _InsertAction extends StatefulWidget {
  /// Creates an [_InsertAction] widget.
  ///
  /// This constructor requires a [label] to describe the action, and an optional
  /// [onTap] callback that is executed when the action is triggered.
  const _InsertAction({required this.label, this.onTap});

  /// The text that describes the action this widget represents.
  ///
  /// It is displayed as part of the widget to provide users with information
  /// about the action that will be triggered upon interaction. This label is
  /// essential for understanding the context of the action and is used for
  /// accessibility purposes as well.
  final String label;

  /// Called when the insert action is tapped.
  ///
  /// This callback is invoked when the user taps on the insert action widget.
  /// It can be used to execute any logic such as navigation, displaying a dialog,
  /// or any other interactive behavior associated with this action.
  final void Function()? onTap;

  @override
  State<_InsertAction> createState() => __InsertActionState();
}

/// Represents the state for a [_InsertAction] widget.
///
/// This stateful widget reacts to user interactions with the [_InsertAction] widget.
/// It manages the widget's state and builds the UI with a gesture detector to handle taps.
/// When the [_InsertAction] widget is tapped, it triggers the provided [onTap] callback.
class __InsertActionState extends State<_InsertAction> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: FormItem(
        bordered: false,
        label: '',
        leading: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ),
        child: Text(widget.label, style: bodySmall),
      ),
    );
  }
}
