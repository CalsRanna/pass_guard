import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/state/global.dart';
import 'package:password_generator/state/password.dart';
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
  late TextEditingController commentController;
  String name = '';
  late TextEditingController nameController;
  bool obscureText = true;
  String password = '';
  late TextEditingController passwordController;
  bool showGenerator = false;
  late TextEditingController usernameController;

  @override
  void initState() {
    commentController = TextEditingController();
    nameController = TextEditingController();
    nameController.addListener(() {
      setState(() {
        name = nameController.text;
      });
    });
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    passwordController.addListener(() {
      setState(() {
        password = passwordController.text;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.id != null) {
      final item =
          context.ref.watch(passwordEmitter(widget.id!).asyncData).data;
      commentController.text = item?.comment ?? '';
      nameController.text = item?.name ?? '';
      usernameController.text = item?.username ?? '';
      passwordController.text = item?.password ?? '';
      password = item?.password ?? '';
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    commentController.dispose();
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
          TextButton(
            onPressed: handleConfirm,
            child: const Text('存储'),
          )
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
              label: '标题',
              child: Input(
                initValue: name,
                placeholder: '添加标题',
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
          ),
          FormGroup(
            child: Column(
              children: [
                FormItem(
                  label: '用户名',
                  child: Input(controller: usernameController),
                ),
                Divider(height: 1, color: surfaceVariant),
                FormItem(
                  label: '电子邮箱',
                  child: Input(controller: usernameController),
                ),
                Divider(height: 1, color: surfaceVariant),
                FormItem(
                  label: '密码',
                  child: Row(
                    children: [
                      Expanded(
                        child: Input(
                          controller: passwordController,
                          placeholder: '密码',
                          type:
                              obscureText ? InputType.password : InputType.text,
                        ),
                      ),
                      GestureDetector(
                        onTap: switchObscureText,
                        child: Icon(
                          obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: primary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: toggleGenerator,
                        child: Icon(
                          Icons.settings_outlined,
                          color: primary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                _PasswordGenerator(
                  password: password,
                  showGenerator: showGenerator,
                  onGenerated: handleGenerated,
                ),
                FormItem(
                  label: '网站',
                  child: Input(
                    controller: usernameController,
                  ),
                ),
                Divider(height: 1, color: surfaceVariant),
                const _InsertField(label: '添加字段'),
              ],
            ),
          ),
          FormGroup(
            title: '其他详细信息',
            child: Column(
              children: [
                FormItem(
                  label: '电话号码',
                  child: Input(controller: nameController),
                ),
                Divider(height: 1, color: surfaceVariant),
                FormItem(
                  label: '一次性代码',
                  child: Input(controller: nameController),
                ),
                Divider(height: 1, color: surfaceVariant),
                FormItem(
                  label: '密码保护的提问',
                  child: Input(controller: nameController),
                ),
                Divider(height: 1, color: surfaceVariant),
                FormItem(
                  label: '密码保护的答案',
                  child: Input(controller: nameController),
                ),
                Divider(height: 1, color: surfaceVariant),
                const _InsertField(label: '添加字段'),
              ],
            ),
          ),
          const FormGroup(
            title: '附件',
            child: _InsertField(label: '添加文件'),
          ),
          FormGroup(
            child: FormItem(
              label: '备注',
              child: Input(controller: commentController, placeholder: '备注'),
            ),
          ),
          const FormGroup(
            child: _InsertField(label: '添加小节'),
          ),
        ],
      ),
    );
  }

  void switchObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void handleConfirm() async {
    final ref = context.ref;
    var record = Password(
      comment: commentController.text,
      name: name,
      username: usernameController.text,
      password: password,
    );
    print(name);
    final router = Navigator.of(context);
    final database = await context.ref.read(databaseEmitter);
    if (widget.id == null) {
      await database.passwordDao.insertPassword(record);
    } else {
      final newPassword = record.copyWith(id: widget.id);
      await database.passwordDao.updatePassword(newPassword);
      ref.emit(passwordEmitter(widget.id!), newPassword);
    }
    Hive.box('setting').put(
      'local_version',
      DateTime.now().millisecondsSinceEpoch,
    );
    final passwords = await database.passwordDao.getAllPasswords();
    ref.emit(allPasswordsEmitter, passwords);
    router.pop();
  }

  void handlePop() {
    Navigator.of(context).pop();
  }

  void toggleGenerator() {
    if (password.isEmpty) {
      passwordController.text = PasswordGenerator(
        hasNumber: true,
        hasSpecialCharacter: true,
        length: 16,
      ).generate();
    }
    setState(() {
      showGenerator = !showGenerator;
    });
  }

  void handleGenerated(String password) {
    passwordController.text = password;
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
    final ref = context.ref;
    final router = Navigator.of(context);
    final password = Password(
      id: widget.id,
      name: nameController.text,
      username: usernameController.text,
      password: passwordController.text,
    );
    final database = await context.ref.read(databaseEmitter);
    await database.passwordDao.deletePassword(password);
    Hive.box('setting').put(
      'local_version',
      DateTime.now().millisecondsSinceEpoch,
    );
    final passwords = await database.passwordDao.getAllPasswords();
    ref.emit(allPasswordsEmitter, passwords);
    router.popUntil(ModalRoute.withName('/'));
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
  const _InsertField({required this.label});

  final String label;

  @override
  State<_InsertField> createState() => __InsertFieldState();
}

class __InsertFieldState extends State<_InsertField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    return FormItem(
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
    );
  }
}
