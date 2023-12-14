import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_generator/util/password_generator.dart';
import 'package:password_generator/widget/form_group.dart';
import 'package:password_generator/widget/form_item.dart';

/// A stateful widget that provides an interface for generating secure passwords.
///
/// This page allows users to specify their preferences for password generation,
/// such as length, inclusion of numbers, and symbols. The generated password can
/// then be used for various authentication purposes. It also provides options
/// to copy the generated password to the clipboard or to navigate to other pages
/// for additional actions.
///
/// The [PasswordGeneratorPage] takes an optional [Key] parameter to initialize its state
/// and a [plain] flag that modifies the behavior of the primary button. Depending on the
/// value of [plain], the primary button either copies the password to the clipboard or
/// navigates back while returning the generated password.
class PasswordGeneratorPage extends StatefulWidget {
  /// Indicates the primary action of the button when generating a password.
  ///
  /// If [plain] is set to `true`, the primary button is used to copy the generated password
  /// to the clipboard. This is useful when the password needs to be pasted elsewhere or saved
  /// for future use.
  ///
  /// If [plain] is set to `false`, the primary button will pop the current page and take the
  /// generated password along with it, allowing the password to be used in a different part of
  /// the application, such as setting it for a new account or updating it for an existing one.
  final bool plain;

  /// Initializes a [PasswordGeneratorPage] widget.
  ///
  /// This constructor takes an optional [Key] as its parameter to initialize the widget.
  /// It also accepts a [plain] flag that determines the behavior of the primary button.
  ///
  /// When [plain] is true, the primary button copies the generated password to the clipboard.
  /// When [plain] is false, the primary button pops the current page and passes the generated
  /// password to the next page for further use.
  ///
  /// The default behavior is to have the [plain] flag set to true.
  ///
  /// - Parameters:
  ///   - key: The [Key] for the [PasswordGeneratorPage] widget.
  ///   - plain: The flag that controls the primary button's action.
  const PasswordGeneratorPage({super.key, this.plain = true});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

/// State management for [PasswordGeneratorPage].
///
/// This class holds the state for the password generator page, including the
/// generated password, user-selected options for password complexity, and
/// password strength level. It manages the generation of a new password based
/// on the specified criteria and updates the UI accordingly.
class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  /// Defines a list of accent colors corresponding to password strength levels.
  ///
  /// Each color in the list is intended to be used as an accent for the corresponding
  /// strength level of the generated password, providing a stronger visual impact.
  /// These accent colors are variants of the main strength level colors, typically
  /// darker shades, meant to complement or highlight the primary colors.
  ///
  /// Accent Colors:
  /// - `0`: Very Weak (Darker Red)
  /// - `1`: Weak (Darker Deep Orange)
  /// - `2`: Fair (Darker Orange)
  /// - `3`: Strong (Darker Light Green)
  /// - `4`: Very Strong (Darker Green)
  List<Color?> accentColors = [
    Colors.red[700],
    Colors.deepOrange[700],
    Colors.orange[700],
    Colors.lightGreen[700],
    Colors.green[700],
  ];

  /// Defines a list of colors corresponding to password strength levels.
  ///
  /// Each color in the list represents a visual feedback for a particular
  /// strength level of the generated password, with the first color indicating
  /// the weakest and the last color indicating the strongest password strength.
  ///
  /// Levels:
  /// - `0`: Very Weak (Red)
  /// - `1`: Weak (Deep Orange)
  /// - `2`: Fair (Orange)
  /// - `3`: Strong (Light Green)
  /// - `4`: Very Strong (Green)
  List<Color> colors = [
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.lightGreen,
    Colors.green,
  ];

  /// Indicates whether the generated password will include numbers.
  ///
  /// When [hasNumber] is set to `true`, the generated password will contain
  /// numeric characters. This property can be modified to toggle the inclusion
  /// of numbers in the password. By default, it is set to `true`, meaning that
  /// number inclusion is enabled.
  bool hasNumber = true;

  /// Indicates whether the generated password will include special characters.
  ///
  /// When [hasSpecialCharacter] is set to `true`, the generated password will include
  /// at least one special character from a predefined set. This enhances the complexity
  /// and security of the password. If set to `false`, the password will not contain
  /// any special characters. By default, this value is set to `true`.
  bool hasSpecialCharacter = true;

  /// The length of the password to generate.
  ///
  /// This value specifies the total number of characters the password should have.
  /// It impacts the complexity and security level of the password. A longer password
  /// is generally more secure. The default value is set to 32 characters.
  double length = 32;

  /// The strength level of the generated password.
  ///
  /// This value is an integer representing the security level of the generated password,
  /// typically determined by analyzing the complexity of the password, such as the mix of
  /// characters, numbers, and special characters used, as well as the length of the password.
  /// The level is used to provide the user with visual feedback on the password's strength,
  /// usually through a color-coded indicator. The levels are mapped to a list of colors
  /// where `0` represents the weakest and the highest index represents the strongest password.
  int level = 0;

  /// Describes the strength levels of the generated password.
  ///
  /// Each string in this list corresponds to a label that represents the password strength:
  /// - `0`: "很差" means "Very Weak"
  /// - `1`: "弱" means "Weak"
  /// - `2`: "一般" means "Fair"
  /// - `3`: "好" means "Strong"
  /// - `4`: "非常好" means "Very Strong"
  ///
  /// These labels provide a user-friendly way to display the strength of a password
  /// and are typically used in conjunction with a visual indicator.
  List<String> levels = [
    '很差',
    '弱',
    '一般',
    '好',
    '非常好',
  ];

  /// Represents the generated password state.
  ///
  /// This variable holds the current state of the generated password after
  /// applying user preferences like length, inclusion of numbers, and special
  /// characters. It is used within the UI to display the generated password
  /// to the user.
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: handleRefresh,
                icon: const Icon(Icons.refresh_outlined),
              ),
              IconButton(
                onPressed: handleCopy,
                icon: const Icon(Icons.copy_outlined),
              )
            ],
            backgroundColor: colors[level],
            collapsedHeight: 96 + 64 + 56,
            elevation: 0,
            expandedHeight: 96 + 64 + 56,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 96,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      password.runes
                          .map((code) => String.fromCharCode(code))
                          .join('\u200B'),
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    color: accentColors[level],
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          levels[level],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.plain)
                          ElevatedButton(
                            onPressed: handleCopy,
                            child: const Text('复制'),
                          )
                        else
                          ElevatedButton(
                            onPressed: handleUse,
                            child: const Text('使用'),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            foregroundColor: Colors.white,
            pinned: true,
            surfaceTintColor: Colors.transparent,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              FormGroup(
                child: FormItem(
                  bordered: false,
                  label: '长度',
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider.adaptive(
                          max: 128,
                          min: 4,
                          value: length,
                          onChanged: changeLength,
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        child: Text(
                          length.toInt().toString(),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(width: 8)
                    ],
                  ),
                ),
              ),
              FormGroup(
                title: '包括',
                child: Column(
                  children: [
                    FormItem(
                      label: '数字',
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Switch.adaptive(
                          value: hasNumber,
                          onChanged: changeHasNumber,
                        ),
                      ),
                    ),
                    FormItem(
                      bordered: false,
                      label: '特殊字符',
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Switch.adaptive(
                          value: hasSpecialCharacter,
                          onChanged: changeHasSpecialCharacter,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  /// Updates the state to reflect whether numbers should be included in the password.
  ///
  /// This method is called when the user toggles the switch for including numbers in the password.
  /// It sets the `hasNumber` state to the given [value] and triggers the password generation.
  ///
  /// [value] indicates whether numbers should be included (`true`) or not (`false`).
  void changeHasNumber(bool value) {
    setState(() {
      hasNumber = value;
    });
    generatePassword();
  }

  /// Updates the state to reflect whether special characters should be included in the password.
  ///
  /// This method is called when the user toggles the switch for including special characters in the password.
  /// It sets the `hasSpecialCharacter` state to the given [value] and triggers the password generation.
  ///
  /// [value] indicates whether special characters should be included (`true`) or not (`false`).
  void changeHasSpecialCharacter(bool value) {
    setState(() {
      hasSpecialCharacter = value;
    });
    generatePassword();
  }

  /// Updates the state to reflect the new length of the password.
  ///
  /// This method is called when the user moves the slider to set a new password length.
  /// It sets the `length` state to the given [value] and triggers the password generation.
  ///
  /// [value] is the new length of the password, represented as a `double`.
  void changeLength(double value) {
    setState(() {
      length = value;
    });
    generatePassword();
  }

  /// Generates a password based on the current criteria.
  ///
  /// This method utilizes the `PasswordGenerator` class to create a new password
  /// with the specified length, including numbers and special characters as per
  /// the current state of `hasNumber` and `hasSpecialCharacter`. After the password
  /// is generated, the state is updated with the new password and its strength level.
  void generatePassword() {
    final generator = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
      length: length.toInt(),
    );
    setState(() {
      password = generator.generate();
      level = generator.calculateStrengthLevel(password);
    });
  }

  /// Copies the current password to the clipboard and displays a snackbar.
  ///
  /// This method sets the current password to the clipboard for user convenience.
  /// After copying, it presents a snackbar to inform the user that the action
  /// has been successful.
  void handleCopy() {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('复制成功'),
      width: 96,
    ));
  }

  /// Refreshes the password by generating a new one.
  ///
  /// This method invokes the [generatePassword] method to create a new
  /// password based on the current settings for length, numbers,
  /// and special characters. The new password replaces the existing one
  /// in the state.
  void handleRefresh() {
    generatePassword();
  }

  /// Pops the current route and passes the generated password back to the previous screen.
  ///
  /// This method is called when the user decides to use the generated password.
  /// It retrieves the current password from the state and uses the `GoRouter`
  /// to pop the current route, while returning the password to the calling screen.
  void handleUse() {
    GoRouter.of(context).pop(password);
  }

  @override
  void initState() {
    super.initState();
    generatePassword();
  }
}
