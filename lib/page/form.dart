import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_generator/component/add_tag.dart';
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
    final labelStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 18,
      fontWeight: FontWeight.w900,
    );
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
                  children: [
                    TextIcon(text: name),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(hintText: '名称'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: '用户名称'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '用户名称不能为空';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(labelText: '密码'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '密码不能为空';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: toggleGenerator,
                        )
                      ],
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
            // const SizedBox(height: 16),
            // Card(
            //   margin: const EdgeInsets.all(0),
            //   shape: const BeveledRectangleBorder(),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('标签', style: labelStyle),
            //         Watcher((context, ref, _) {
            //           return Wrap(
            //             children: const [AdditionTag()],
            //           );
            //         }),
            //       ],
            //     ),
            //   ),
            // ),
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
                      decoration: const InputDecoration(labelText: '备注'),
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

  void handleConfirm(BuildContext context) async {
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
        context.ref.emit(passwordEmiiter(widget.id!), newPassword);
      }
      Hive.box('setting').put(
        'local_version',
        DateTime.now().millisecondsSinceEpoch,
      );
      final passwords = await database.passwordDao.getAllPasswords();
      context.ref.emit(allPasswordsEmitter, passwords);
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
                    onPressed: () => cancelDelete(context),
                    child: const Text('取消')),
                TextButton(
                  onPressed: () => confirmDelete(context),
                  child: const Text(
                    '删除',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ));
  }

  void cancelDelete(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirmDelete(BuildContext context) async {
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
    context.ref.emit(allPasswordsEmitter, passwords);
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
    Widget child = TextButton(
      onPressed: toggleShowPassword,
      child: SizedBox(
        width: double.infinity,
        child: Text(showPassword ? widget.password : '显示密码'),
      ),
    );
    if (widget.showGenerator) {
      child = Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
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
                  min: 8,
                  max: 64,
                  value: length,
                  onChanged: handleSliderChanged,
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
    final password = PasswordGenerator(
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
      length: value.toInt(),
    ).generate();
    setState(() {
      length = value;
    });
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
