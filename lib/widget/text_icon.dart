import 'package:flutter/material.dart';
import 'package:password_generator/util/random_color.dart';

class TextIcon extends StatelessWidget {
  const TextIcon({super.key, this.size, required this.text});

  final Size? size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RandomColor.fromText(text) ??
            Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      height: size?.height ?? 64,
      width: size?.width ?? 64,
      child: Align(
        child: Text(
          text.length > 1 ? text.substring(0, 1) : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: (size?.width ?? 64) - 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
