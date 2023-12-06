import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/isar.dart';
import 'package:password_generator/util/password_generator.dart';
import 'package:password_generator/widget/form_group.dart';
import 'package:password_generator/widget/form_item.dart';
import 'package:password_generator/widget/input.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key, this.id});

  final int? id;

  @override
  State<PasswordForm> createState() {
    return _PasswordFormState();
  }
}

class _PasswordFormState extends State<PasswordForm> {
  String name = '';
  bool obscureText = true;
  String password = '';
  bool showGenerator = false;

  var guard = Guard();

  @override
  void initState() {
    // commentController = TextEditingController();
    // nameController = TextEditingController();
    // nameController.addListener(() {
    //   setState(() {
    //     name = nameController.text;
    //   });
    // });
    // usernameController = TextEditingController();
    // passwordController = TextEditingController();
    // passwordController.addListener(() {
    //   setState(() {
    //     password = passwordController.text;
    //   });
    // });
    super.initState();
    initGuard();
  }

  void initGuard() async {
    guard = await isar.guards.get(widget.id ?? 0) ?? Guard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surfaceVariant;
    final primary = colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(builder: (context, ref, child) {
            final notifier = ref.read(guardListNotifierProvider.notifier);
            return TextButton(
              onPressed:
                  guard.title.isNotEmpty ? () => handleConfirm(notifier) : null,
              child: const Text('存储'),
            );
          })
        ],
        leading: TextButton(
          onPressed: handlePop,
          child: const Text('取消'),
        ),
        title: Text(widget.id == null ? '添加' : '修改'),
      ),
      body: ListView(
        children: [
          FormGroup(
            child: FormItem(
              bordered: false,
              label: '标题',
              child: Input(
                initValue: guard.title,
                placeholder: '添加标题',
                onChanged: (value) {
                  setState(() {
                    guard.title = value;
                  });
                },
              ),
            ),
          ),
          for (final segment in guard.segments)
            FormGroup(
              title: segment.title,
              child: Column(
                children: [
                  for (final field in segment.fields)
                    FormItem(
                      label: field.label,
                      child: Input(
                        initValue: field.value,
                        onChanged: (value) {
                          setState(() {
                            field.value = value;
                          });
                        },
                      ),
                    ),
                  _InsertAction(
                    label: '添加字段',
                    onTap: () => handleInsertField(segment),
                  ),
                ],
              ),
            ),
          FormGroup(
            child: _InsertAction(
              label: '添加小节',
              onTap: handleInsertSegment,
            ),
          ),
        ],
      ),
    );
  }

  void handleInsertField(Segment segment) async {
    final field = await const InsertFieldPageRoute().push(context);
    if (field != null) {
      setState(() {
        segment.fields.add(field);
      });
    }
  }

  void handleInsertSegment() async {
    final name = await const InsertSegmentPageRoute().push(context);
    if (name != null) {
      setState(() {
        final segment = Segment();
        segment.title = name;
        guard.segments.add(segment);
      });
    }
  }

  void switchObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void handleConfirm(GuardListNotifier notifier) async {
    notifier.addGuard(guard);
    if (mounted) {
      GoRouter.of(context).pop();
    }

    // final ref = context.ref;
    // var record = Password(
    //   comment: commentController.text,
    //   name: name,
    //   username: usernameController.text,
    //   password: password,
    // );
    // final router = Navigator.of(context);
    // final database = await context.ref.read(databaseEmitter);
    // if (widget.id == null) {
    //   await database.passwordDao.insertPassword(record);
    // } else {
    //   final newPassword = record.copyWith(id: widget.id);
    //   await database.passwordDao.updatePassword(newPassword);
    //   ref.emit(passwordEmitter(widget.id!), newPassword);
    // }
    // Hive.box('setting').put(
    //   'local_version',
    //   DateTime.now().millisecondsSinceEpoch,
    // );
    // final passwords = await database.passwordDao.getAllPasswords();
    // ref.emit(allPasswordsEmitter, passwords);
    // router.pop();
  }

  void handlePop() {
    Navigator.of(context).pop();
  }

  void toggleGenerator() {
    // if (password.isEmpty) {
    //   passwordController.text = PasswordGenerator(
    //     hasNumber: true,
    //     hasSpecialCharacter: true,
    //     length: 16,
    //   ).generate();
    // }
    // setState(() {
    //   showGenerator = !showGenerator;
    // });
  }

  void handleGenerated(String password) {
    // passwordController.text = password;
  }

  void handleDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('你确定要删除“$name”吗?'),
        content: const Text('此密码将被立即移除，并且无法再次找回。'),
        actions: [
          TextButton(
              onPressed: () => cancelDelete(context), child: const Text('取消')),
          TextButton(
            onPressed: () => confirmDelete(context),
            child: const Text(
              '删除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void cancelDelete(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirmDelete(BuildContext context) async {
    // final ref = context.ref;
    // final router = Navigator.of(context);
    // final password = Password(
    //   id: widget.id,
    //   name: nameController.text,
    //   username: usernameController.text,
    //   password: passwordController.text,
    // );
    // final database = await context.ref.read(databaseEmitter);
    // await database.passwordDao.deletePassword(password);
    // Hive.box('setting').put(
    //   'local_version',
    //   DateTime.now().millisecondsSinceEpoch,
    // );
    // final passwords = await database.passwordDao.getAllPasswords();
    // ref.emit(allPasswordsEmitter, passwords);
    // router.popUntil(ModalRoute.withName('/'));
  }
}

class _PasswordGenerator extends StatefulWidget {
  const _PasswordGenerator({
    required this.password,
    required this.showGenerator,
    this.onGenerated,
  });

  final String password;
  final bool showGenerator;
  final void Function(String)? onGenerated;

  @override
  State<_PasswordGenerator> createState() => __PasswordGeneratorState();
}

class __PasswordGeneratorState extends State<_PasswordGenerator> {
  bool hasNumber = true;
  bool hasSpecialCharacter = true;
  double length = 16;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();
    if (widget.showGenerator) {
      child = Card(
        color: Theme.of(context).colorScheme.surfaceVariant,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(widget.password)),
                    IconButton(
                      icon: const Icon(Icons.refresh_outlined),
                      onPressed: handleButtonPressed,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(width: 96, child: Text('${length.toInt()}位密码')),
                  Expanded(
                    child: Slider.adaptive(
                      divisions: 52,
                      min: 8,
                      max: 64,
                      value: length,
                      onChanged: handleSliderChanged,
                      onChangeEnd: handleSliderChangeEnd,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('特殊符号'),
                  const Expanded(child: SizedBox()),
                  Switch.adaptive(
                    value: hasSpecialCharacter,
                    onChanged: handleSpecialCharacterSwitchChanged,
                  )
                ],
              ),
              Row(
                children: [
                  const Text('数字'),
                  const Expanded(child: SizedBox()),
                  Switch.adaptive(
                    value: hasNumber,
                    onChanged: handleNumberSwitchChanged,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void handleButtonPressed() {
    final password = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
      length: length.toInt(),
    ).generate();
    widget.onGenerated?.call(password);
  }

  void handleSliderChanged(double value) {
    setState(() {
      length = value;
    });
  }

  void handleSliderChangeEnd(double value) {
    final password = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
      length: value.toInt(),
    ).generate();
    widget.onGenerated?.call(password);
  }

  void handleSpecialCharacterSwitchChanged(bool value) {
    final password = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: value,
      length: length.toInt(),
    ).generate();
    setState(() {
      hasSpecialCharacter = value;
    });
    widget.onGenerated?.call(password);
  }

  void handleNumberSwitchChanged(bool value) {
    final password = PasswordGenerator(
      hasNumber: value,
      hasSpecialCharacter: hasSpecialCharacter,
      length: length.toInt(),
    ).generate();
    setState(() {
      hasNumber = value;
    });
    widget.onGenerated?.call(password);
  }
}

class _InsertField extends StatefulWidget {
  const _InsertField({required this.label, this.onTap});

  final String label;
  final void Function()? onTap;

  @override
  State<_InsertField> createState() => __InsertFieldState();
}

class __InsertFieldState extends State<_InsertField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: FormItem(
        label: '',
        leading: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ),
        child: Text(widget.label, style: bodySmall),
      ),
    );
  }
}

class _InsertAction extends StatefulWidget {
  const _InsertAction({required this.label, this.onTap});

  final String label;
  final void Function()? onTap;

  @override
  State<_InsertAction> createState() => __InsertActionState();
}

class __InsertActionState extends State<_InsertAction> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: FormItem(
        bordered: false,
        label: '',
        leading: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ),
        child: Text(widget.label, style: bodySmall),
      ),
    );
  }
}
