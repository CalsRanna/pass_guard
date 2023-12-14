import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

/// A utility class for generating random passwords.
///
/// This class allows configuration to include or exclude numbers
/// and special characters in the generated password. The default
/// password length is 32 characters but can be adjusted.
///
/// Parameters:
///   [hasNumber]: Determines if the password should contain numbers.
///   [hasSpecialCharacter]: Determines if the password should contain special characters.
///   [length]: The length of the generated password.
class PasswordGenerator {
  /// Indicates whether the generated password will include numbers.
  ///
  /// When set to `true`, the password will contain numeric characters, adding to its complexity.
  /// If set to `false`, numeric characters will be excluded from the password.
  /// Defaults to `true`, ensuring numbers are included unless explicitly turned off.
  final bool hasNumber;

  /// Indicates whether the generated password will include special characters.
  ///
  /// When set to `true`, the password will contain characters like `!`, `@`, `#`, etc.,
  /// adding to its complexity and strength. If set to `false`, these characters will be
  /// excluded from the password. Defaults to `true`, ensuring special characters are
  /// included unless explicitly turned off.
  final bool hasSpecialCharacter;

  /// The length of the password to be generated.
  ///
  /// Specifies the total number of characters the password will contain.
  /// A longer password typically increases security by making it more
  /// resistant to guessing and brute-force attacks. The length must be
  /// a positive integer, and it influences the composition of the password
  /// when combined with other settings like [hasNumber] and [hasSpecialCharacter].
  ///
  /// Defaults to 32 characters.
  final int length;

  /// Creates a [PasswordGenerator] with configurable options for password complexity.
  ///
  /// This constructor allows setting preferences for the inclusion of numbers and
  /// special characters, as well as the desired password length. By default, it
  /// generates a password with numbers, special characters, and a length of 32
  /// characters if no parameters are provided.
  ///
  /// Parameters:
  ///   [hasNumber]: (optional) A boolean value that determines if the generated
  ///                password should contain numbers. Defaults to `true`.
  ///   [hasSpecialCharacter]: (optional) A boolean value that determines if the
  ///                          generated password should contain special characters.
  ///                          Defaults to `true`.
  ///   [length]: (optional) An integer value that sets the length of the generated
  ///             password. Defaults to 32.
  PasswordGenerator({
    this.hasNumber = true,
    this.hasSpecialCharacter = true,
    this.length = 32,
  });

  /// Calculates the strength level of a given password.
  ///
  /// This function evaluates the password based on various criteria such as
  /// length, the use of lowercase and uppercase letters, numbers, and special
  /// characters. The strength level is an integer between 0 and 4, with higher
  /// values indicating a stronger password.
  ///
  /// The criteria for scoring are as follows:
  /// - Length: Up to 20 points, 1 point for each character.
  /// - Lowercase letters: 1 point each.
  /// - Digits: 1 point each.
  /// - Uppercase letters: 2 points each.
  /// - Special characters (non-alphanumeric): 3 points each.
  ///
  /// Scores are clamped to a maximum of 100 before scaling to the final strength level.
  ///
  /// - Parameters:
  ///   - password: The password string to be evaluated.
  /// - Returns: An integer between 0 and 4 representing the password strength level.
  int calculateStrengthLevel(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    score += password.length.clamp(0, 20);
    score += RegExp(r'[a-z]').allMatches(password).length;
    score += RegExp(r'\d').allMatches(password).length;
    score += RegExp(r'[A-Z]').allMatches(password).length * 2;
    score += RegExp(r'[\W_]').allMatches(password).length * 3;
    score = score.clamp(0, 100);
    return _scaledScore(score);
  }

  /// Generates a random password based on the configured settings.
  ///
  /// This method creates a password string that adheres to the constraints
  /// of having numbers and/or special characters if specified, and with a
  /// length as set by the [length] property. It ensures that the password
  /// does not contain unwanted characters by repeatedly generating a random
  /// character until it meets the criteria.
  ///
  /// Returns:
  ///   A `String` containing the generated password that meets the specified
  ///   criteria for numbers, special characters, and length.
  String generate() {
    var characters = <int>[];
    for (var i = 0; i < length; i++) {
      var ascii = Random().nextInt(127);
      if (ascii < 33) {
        ascii = ascii + 33;
      }
      if ((!hasNumber && _isNumber(ascii)) ||
          (!hasSpecialCharacter && _isSpecialCharacter(ascii)) ||
          ascii == 34 ||
          ascii == 39) {
        i = i - 1;
      } else {
        characters.add(ascii);
      }
    }
    return const Utf8Codec().decode(Uint8List.fromList(characters));
  }

  /// Determines if the provided ASCII value corresponds to a numeric character.
  ///
  /// The ASCII values for numeric characters range from 48 ('0') to 57 ('9').
  /// This function checks whether the given ASCII value falls within this range.
  ///
  /// Parameters:
  ///   [ascii]: The ASCII value to check.
  ///
  /// Returns:
  ///   A `bool` indicating whether the ASCII value is a numeric character.
  bool _isNumber(int ascii) {
    return ascii >= 48 && ascii <= 57;
  }

  /// Determines if the provided ASCII value corresponds to a special character.
  ///
  /// The ASCII values for special characters are not continuous and are divided
  /// into several ranges. This function checks whether the given ASCII value falls
  /// within any of these ranges, which include typical special characters and punctuation.
  ///
  /// Parameters:
  ///   - [ascii]: The ASCII value to check.
  ///
  /// Returns:
  ///   A `bool` indicating whether the ASCII value is a special character.
  bool _isSpecialCharacter(int ascii) {
    bool validated;
    if (ascii >= 33 && ascii <= 47) {
      validated = true;
    } else if (ascii >= 58 && ascii <= 64) {
      validated = true;
    } else if (ascii >= 91 && ascii <= 96) {
      validated = true;
    } else if (ascii >= 123 && ascii <= 126) {
      validated = true;
    } else {
      validated = false;
    }
    return validated;
  }

  /// Scales the given score to a strength level.
  ///
  /// This function takes a score assumed to be out of 100 and converts it into
  /// a strength level from 0 to 4. The conversion is based on predefined
  /// percentage thresholds. Higher percentages indicate stronger passwords.
  ///
  /// - Parameters:
  ///   - score: The score to be scaled, expected to be in the range 0 to 100.
  /// - Returns: An integer representing the strength level, where:
  ///   - 0 represents a very weak password.
  ///   - 1 represents a weak password.
  ///   - 2 represents a fair password.
  ///   - 3 represents a strong password.
  ///   - 4 represents a very strong password.
  int _scaledScore(int score) {
    final double percentage = score / 100;
    if (percentage >= 0.6) return 4;
    if (percentage >= 0.4) return 3;
    if (percentage >= 0.3) return 2;
    if (percentage >= 0.2) return 1;
    return 0;
  }
}
