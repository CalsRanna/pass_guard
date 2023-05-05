import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/state/global.dart';
import 'package:password_generator/state/password.dart';
import 'package:password_generator/util/password_generator.dart';
import 'package:password_generator/widget/text_icon.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key, this.id});

  final int? id;

  @override
  State<PasswordForm> createState() {
    return _PasswordFormState();
  }
}

class _PasswordFormState extends State<PasswordForm> {
  final formKey = GlobalKey<FormState>();
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
      final password =
          context.ref.watch(passwordEmiiter(widget.id!).asyncData).data;
      commentController.text = password?.comment ?? '';
      nameController.text = password?.name ?? '';
      usernameController.text = password?.username ?? '';
      passwordController.text = password?.password ?? '';
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
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextIcon(size: const Size.square(48), text: name),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          filled: true,
                          hintText: '名称',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '名称不能为空';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  runSpacing: 8,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        filled: true,
                        hintText: '用户名称',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '用户名称不能为空';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        filled: true,
                        hintText: '密码',
                        suffixIcon: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: switchObscureText,
                              child: Icon(
                                obscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings_outlined),
                              onPressed: toggleGenerator,
                            ),
                          ],
                        ),
                      ),
                      obscureText: obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '密码不能为空';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _PasswordGenerator(
                      password: password,
                      showGenerator: showGenerator,
                      onGenerated: handleGenerated,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        filled: true,
                        hintText: '备注',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.id != null)
              TextButton(
                onPressed: () => handleDelete(context),
                child: const Text(
                  '删除',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void switchObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void handleConfirm(BuildContext context) async {
    final ref = context.ref;
    if (formKey.currentState!.validate()) {
      var password = Password(
        comment: commentController.text,
        name: nameController.text,
        username: usernameController.text,
        password: passwordController.text,
      );
      final router = Navigator.of(context);
      final database = await context.ref.read(databaseEmitter);
      if (widget.id == null) {
        await database.passwordDao.insertPassword(password);
      } else {
        final newPassword = password.copyWith(id: widget.id);
        await database.passwordDao.updatePassword(newPassword);
        ref.emit(passwordEmiiter(widget.id!), newPassword);
      }
      Hive.box('setting').put(
        'local_version',
        DateTime.now().millisecondsSinceEpoch,
      );
      final passwords = await database.passwordDao.getAllPasswords();
      ref.emit(allPasswordsEmitter, passwords);
      router.pop();
    }
  }

  void handlePop(BuildContext context) {
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
        content: const Text('此项目将被立即移除，并且无法再次找回。'),
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
      child = Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.tertiary),
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
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
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
