import 'package:flutter/material.dart';

class RandomColor {
  static Color? fromText(String? text) {
    if (text == null || text.length < 4) {
      return null;
    } else {
      final red = text.codeUnitAt(0);
      final green = text.codeUnitAt(1);
      final blue = text.codeUnitAt(2);
      return Color.fromRGBO(red, green, blue, 1);
    }
  }
}
