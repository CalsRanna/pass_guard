import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/widget/form_group.dart';
import 'package:password_generator/widget/form_item.dart';
import 'package:password_generator/widget/input.dart';

class InsertFieldPage extends StatefulWidget {
  const InsertFieldPage({super.key});

  @override
  State<InsertFieldPage> createState() => _InsertFieldPageState();
}

class _InsertFieldPageState extends State<InsertFieldPage> {
  String label = '';
  String type = 'text';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: label.isNotEmpty ? handleSubmit : null,
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
            child: Column(
              children: [
                FormItem(
                  label: '名称',
                  child: Input(
                    initialValue: label,
                    onChanged: (value) {
                      setState(() {
                        label = value;
                      });
                    },
                  ),
                ),
                FormItem(
                  label: '类型',
                  child: Input(
                    initialValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void handleSubmit() {
    final field = Field();
    field.label = label;
    field.type = type;
    GoRouter.of(context).pop(field);
  }

  void handlePop() {
    GoRouter.of(context).pop();
  }
}
