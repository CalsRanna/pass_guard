import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:password_generator/component/add_tag.dart';
import 'package:password_generator/page/form.dart';
import 'package:password_generator/state/password.dart';
import 'package:password_generator/widget/password_item.dart';
import 'package:password_generator/widget/text_icon.dart';

class PasswordDetail extends StatelessWidget {
  const PasswordDetail({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 18,
      fontWeight: FontWeight.w900,
    );
    const textStyle = TextStyle(fontSize: 16);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => handleNavigated(context),
            child: const Text('编辑'),
          )
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(0),
            shape: const BeveledRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Watcher((context, ref, _) => TextIcon(
                      text:
                          ref.watch(passwordEmiiter(id).asyncData).data?.name ??
                              '')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Watcher((context, ref, _) => Text(
                        ref.watch(passwordEmiiter(id).asyncData).data?.name ??
                            '')),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.all(0),
            shape: const BeveledRectangleBorder(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Watcher((context, ref, _) {
                  final password =
                      ref.watch(passwordEmiiter(id).asyncData).data;
                  return PasswordTile(
                    label: '用户名称',
                    text: password?.username ?? '',
                  );
                }),
                Watcher((context, ref, _) {
                  final password =
                      ref.watch(passwordEmiiter(id).asyncData).data;
                  return PasswordTile(
                    label: '密码',
                    obscureText: true,
                    text: password?.password ?? '',
                  );
                }),
              ],
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
          Watcher((context, ref, _) {
            final password = ref.watch(passwordEmiiter(id).asyncData).data;
            if (password?.comment != null && password!.comment!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Card(
                    margin: const EdgeInsets.all(0),
                    shape: const BeveledRectangleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('备注', style: labelStyle),
                          Text(password.comment ?? '', style: textStyle)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          })
        ],
      ),
    );
  }

  void handleNavigated(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => PasswordForm(id: id),
        reverseTransitionDuration: Duration.zero,
        transitionDuration: Duration.zero,
      ),
    );
  }
}
