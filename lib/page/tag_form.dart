import 'package:flutter/material.dart';

class TagForm extends StatefulWidget {
  const TagForm({super.key, this.ids});

  final List<int>? ids;

  @override
  State<TagForm> createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => handleConfirm(context),
            child: const Text('完成'),
          )
        ],
        leading: TextButton(
          onPressed: () => handlePop(context),
          child: const Text('取消'),
        ),
      ),
    );
  }

  void handleConfirm(BuildContext context) async {}

  void handlePop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
