import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/widget/form_group.dart';
import 'package:password_generator/widget/form_item.dart';
import 'package:password_generator/widget/input.dart';

class InsertSegmentPage extends StatefulWidget {
  const InsertSegmentPage({super.key});

  @override
  State<InsertSegmentPage> createState() => _InsertSegmentPageState();
}

class _InsertSegmentPageState extends State<InsertSegmentPage> {
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

  void handleSubmit() {
    GoRouter.of(context).pop(name);
  }

  void handlePop() {
    GoRouter.of(context).pop();
  }
}
