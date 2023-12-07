import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';

class PasswordDetail extends StatelessWidget {
  const PasswordDetail({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final titleLarge = textTheme.titleLarge;
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final bodySmall = textTheme.bodySmall;
    final outlineVariant = colorScheme.outlineVariant.withOpacity(0.25);
    final borderSide = BorderSide(color: outlineVariant);
    final bodyMedium = textTheme.bodyMedium;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => handleNavigated(context),
            child: const Text('编辑'),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Consumer(builder: (context, ref, child) {
        final guard = ref.watch(FindGuardProvider(id));
        final child = switch (guard) {
          AsyncData(:final value) => ListView(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Text(value?.title ?? '', style: titleLarge),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    color: Colors.orange,
                  ),
                  height: 4,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.key_off_outlined,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '弱密码',
                            style: bodySmall?.copyWith(color: Colors.orange),
                          ),
                          Text('此账户的密码不够安全', style: bodySmall)
                        ],
                      )
                    ],
                  ),
                ),
                for (final segment in value?.segments ?? <Segment>[])
                  _SegmentTile(segment: segment),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    border: Border(top: borderSide, bottom: borderSide),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(left: 16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ActionTile(label: '添加到收藏夹', onTap: () {}),
                      _ActionTile(label: '共享', onTap: () {}),
                      _ActionTile(label: '复制', onTap: () {}),
                      _ActionTile(
                        label: '移到垃圾桶',
                        onTap: () => destroyGuard(context, ref),
                      ),
                      _ActionTile(label: '归档', onTap: () {}),
                      _ActionTile(label: '更改类别', onTap: () {}),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '最后一次修改：',
                              style: bodyMedium?.copyWith(color: primary),
                            ),
                            Text(
                              value?.updatedAt.toString() ?? '',
                              style: bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          _ => const CircularProgressIndicator.adaptive(),
        };
        return child;
      }),
    );
  }

  void handleNavigated(BuildContext context) {
    EditGuardRoute(id).push(context);
  }

  void destroyGuard(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(guardListNotifierProvider.notifier);
    await notifier.destroyGuard(id);
    if (!context.mounted) {
      return;
    }
    GoRouter.of(context).pop();
  }
}

class _SegmentTile extends StatelessWidget {
  const _SegmentTile({required this.segment});

  final Segment segment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final bodySmall = textTheme.bodySmall;
    final outlineVariant = colorScheme.outlineVariant.withOpacity(0.25);
    final fullOutlineVariant = colorScheme.outlineVariant;
    final borderSide = BorderSide(color: outlineVariant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Text(
            segment.title,
            style: bodySmall?.copyWith(color: fullOutlineVariant),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(top: borderSide, bottom: borderSide),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(left: 16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < segment.fields.length; i++)
                _FieldTile(
                  bordered: i < segment.fields.length - 1,
                  field: segment.fields[i],
                )
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldTile extends StatefulWidget {
  const _FieldTile({this.bordered = true, required this.field});

  final bool bordered;
  final Field field;

  @override
  State<StatefulWidget> createState() => __FieldTileState();
}

class __FieldTileState extends State<_FieldTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final outlineVariant = colorScheme.outlineVariant.withOpacity(0.25);
    final borderSide = BorderSide(color: outlineVariant);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: widget.bordered ? borderSide : BorderSide.none),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.label,
            style: bodySmall?.copyWith(color: primary),
          ),
          const SizedBox(height: 4),
          Text(
            widget.field.type == 'password'
                ? '••••••••••••••••'
                : widget.field.value,
            style: bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  const _ActionTile({required this.label, this.onTap});

  final String label;
  final void Function()? onTap;

  @override
  State<StatefulWidget> createState() => __ActionTileState();
}

class __ActionTileState extends State<_ActionTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final outlineVariant = colorScheme.outlineVariant.withOpacity(0.25);
    final borderSide = BorderSide(color: outlineVariant);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: borderSide)),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: Text(widget.label, style: bodyMedium?.copyWith(color: primary)),
      ),
    );
  }
}
