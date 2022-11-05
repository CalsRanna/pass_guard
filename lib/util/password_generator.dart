import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

class PasswordGenerator {
  final bool hasNumber;
  final bool hasSpecialCharacter;
  final int length;

  PasswordGenerator({
    this.hasNumber = true,
    this.hasSpecialCharacter = true,
    this.length = 16,
  });

  String generate() {
    var characters = <int>[];
    for (var i = 0; i < length; i++) {
      var ascii = Random().nextInt(127);
      if (ascii < 33) {
        ascii = ascii + 33;
      }

      if ((!hasNumber && isNumber(ascii)) ||
          (!hasSpecialCharacter && isSpecialCharacter(ascii)) ||
          ascii == 34 ||
          ascii == 39) {
        i = i - 1;
      } else {
        characters.add(ascii);
      }
    }
    return const Utf8Codec().decode(Uint8List.fromList(characters));
  }

  bool isNumber(int ascii) {
    bool validated;
    if (ascii >= 48 && ascii <= 57) {
      validated = true;
    } else {
      validated = false;
    }
    return validated;
  }

  bool isSpecialCharacter(int ascii) {
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
}
