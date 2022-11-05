import 'package:flutter/material.dart';
import 'package:password_generator/page/tag_form.dart';

class AdditionTag extends StatelessWidget {
  const AdditionTag({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.add_outlined),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      label: const Text('添加标签'),
      shape: const StadiumBorder(),
      onPressed: () => addTag(context),
    );
  }

  void addTag(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TagForm()),
    );
  }
}
