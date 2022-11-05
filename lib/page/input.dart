import 'package:flutter/material.dart';

class SettingInput extends StatefulWidget {
  const SettingInput({super.key, this.label, this.value});

  final String? label;
  final String? value;

  @override
  State<SettingInput> createState() => _SettingInputState();
}

class _SettingInputState extends State<SettingInput> {
  final controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    controller.text = widget.value ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => handleInput(context),
            child: const Text('完成'),
          )
        ],
        title: widget.label != null ? Text(widget.label!) : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }

  void handleInput(BuildContext context) {
    Navigator.of(context).pop(controller.text);
  }
}
