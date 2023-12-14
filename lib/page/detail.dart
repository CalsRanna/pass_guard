import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/provider/guard.dart';
import 'package:password_generator/router/router.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/util/password_generator.dart';

/// A [StatelessWidget] that displays the detail of a specific password entry.
///
/// It takes an integer [id] which corresponds to the unique identifier of
/// the password entry that will be displayed.
class PasswordDetail extends StatelessWidget {
  /// The unique identifier of the password entry that this widget details.
  ///
  /// This value corresponds to a specific password entry and should be provided
  /// to look up the entry's details for display. It must not be null.
  final int id;

  /// Creates a widget that displays the details of a password entry.
  ///
  /// This widget presents the information associated with the password
  /// whose unique identifier matches the provided [id].
  ///
  /// The [id] parameter must not be null and must correspond to an existing
  /// password entry.
  const PasswordDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final titleLarge = textTheme.titleLarge;
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final bodySmall = textTheme.bodySmall;
    final surfaceVariant = colorScheme.surfaceVariant;
    final borderSide = BorderSide(color: surfaceVariant);
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
        surfaceTintColor: Colors.transparent,
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
                _Indicator(guard: value),
                _IndicatorVariant(guard: value),
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
                        label: '删除',
                        onTap: () => destroyGuard(context, ref, value?.title),
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

  /// Initiates the process to destroy a guard with a confirmation dialog.
  ///
  /// This method shows a confirmation dialog when a user attempts to delete a guard.
  /// If the user confirms, it proceeds with the destruction process and updates
  /// the state accordingly. It uses the [handleCancel] method if the user cancels the action.
  ///
  /// [context] is the [BuildContext] within which this operation is performed.
  /// [ref] is the [WidgetRef] used to access the [guardListNotifierProvider] for state management.
  /// [title] is an optional parameter that can be used to show a custom message on the dialog.
  void destroyGuard(BuildContext context, WidgetRef ref, String? title) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog.adaptive(
        actions: [
          TextButton(
            onPressed: () => handleCancel(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => handleConfirm(context, ref),
            child: const Text('好的'),
          ),
        ],
        backgroundColor: Colors.white,
        title: const Text('警告'),
        content: Text('您确定要删除“$title”吗？'),
      ),
    );
  }

  /// Pops the current route off the navigation stack.
  ///
  /// This method is used to dismiss the current dialog and return to the
  /// previous screen. It is typically called in response to the user pressing
  /// the cancel button in a dialog.
  void handleCancel(BuildContext context) {
    GoRouter.of(context).pop();
  }

  /// Confirms the destruction of a guard and updates the state.
  ///
  /// After confirming the deletion of a guard, it pops the dialog context and
  /// triggers the deletion of the specified guard by its [id]. Once the operation
  /// is complete, it checks if the context is still mounted before popping the
  /// navigation stack again to reflect the changes.
  ///
  /// [context] is the [BuildContext] within which this operation is performed.
  /// [ref] is the [WidgetRef] used to access the [guardListNotifierProvider] for state management.
  void handleConfirm(BuildContext context, WidgetRef ref) async {
    GoRouter.of(context).pop();
    final notifier = ref.read(guardListNotifierProvider.notifier);
    await notifier.destroyGuard(id);
    if (!context.mounted) return;
    GoRouter.of(context).pop();
  }

  /// Navigates to the [EditGuardRoute] with the specified [id].
  ///
  /// This method pushes the [EditGuardRoute] onto the navigation stack,
  /// allowing the user to edit the guard information.
  ///
  /// [context] is the BuildContext from which navigation is initiated.
  void handleNavigated(BuildContext context) {
    EditGuardRoute(id).push(context);
  }
}

/// Represents an actionable tile within the UI.
///
/// This widget is a stateful tile that can perform an action when tapped.
/// It is used to represent an interactive element with a label that triggers
/// an event handler when the user interacts with it.
///
/// The [_ActionTile] takes a [label] which is displayed on the tile and an [onTap]
/// callback which is called when the tile is pressed.
class _ActionTile extends StatefulWidget {
  /// The text label for the action tile.
  ///
  /// This is the text that will be displayed on the tile, indicating
  /// the action that will be performed when the tile is tapped. It is
  /// a required parameter and must not be null.
  final String label;

  /// Called when the tile is tapped.
  ///
  /// This callback is invoked when the user taps on the tile.
  /// If null, then the tile will not react to tap gestures.
  /// Otherwise, it specifies the action to take when the tile is tapped.
  final void Function()? onTap;

  /// Creates an instance of [_ActionTile].
  ///
  /// This constructor requires a [label] to display on the tile. Optionally,
  /// an [onTap] callback can be provided that will be called when the tile is
  /// pressed. If [onTap] is not provided, the tile will not perform any action
  /// when tapped.
  const _ActionTile({required this.label, this.onTap});

  @override
  State<StatefulWidget> createState() => __ActionTileState();
}

/// The `__ActionTileState` class is responsible for creating the visual representation
/// of an [_ActionTile] widget.
///
/// This state object holds the logic and internal state for a [_ActionTile]. It manages
/// the widget's appearance and interactions, such as tap handling. When the [_ActionTile]
/// is tapped, this state class invokes the provided [onTap] callback, if any, and updates
/// the UI accordingly.
///
/// The UI for the [_ActionTile] consists of a container with a bottom border and padding,
/// which contains the text label provided to the [_ActionTile]. The text styling and
/// color are determined by the current theme.
class __ActionTileState extends State<_ActionTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final surfaceVariant = colorScheme.surfaceVariant;
    final borderSide = BorderSide(color: surfaceVariant);
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

/// The [_FieldTile] widget displays a single field within a segment.
///
/// This widget is responsible for rendering the UI representation of a `Field`
/// object. It can show a border if specified. The appearance of the field
/// can be customized via the `bordered` parameter.
class _FieldTile extends StatefulWidget {
  /// Indicates whether a bottom border should be displayed.
  ///
  /// If set to `true`, a visual bottom border is rendered beneath the field tile,
  /// which can be useful for separating each field when displayed in a list view.
  /// If `false`, no border is rendered, providing a seamless appearance.
  final bool bordered;

  /// The data model for a field within a segment.
  ///
  /// This property holds the [Field] object containing the relevant data
  /// to be displayed in the [_FieldTile] widget.
  final Field field;

  /// Creates a widget that represents a field within a segment with an optional border.
  ///
  /// This widget takes a [Field] object to display its data and can be configured
  /// to show a border at the bottom by setting the [bordered] parameter to `true`.
  /// The border visibility helps in distinguishing individual fields when presented
  /// in a list.
  ///
  /// The [field] parameter must not be null and it contains the data for the field
  /// that this widget will display.
  ///
  /// The default value of [bordered] is `true`, which will show the border.
  const _FieldTile({this.bordered = true, required this.field});

  @override
  State<StatefulWidget> createState() => __FieldTileState();
}

/// The [__FieldTileState] is the state for [_FieldTile] widget.
///
/// This class manages the state for the [_FieldTile] widget such as whether
/// the tile is pressed or if the details of the field should be shown.
/// It works in conjunction with [_FieldTile] to present individual field data.
class __FieldTileState extends State<_FieldTile> {
  /// Indicates whether the field tile is currently pressed.
  ///
  /// This variable is a boolean that toggles to true when the user
  /// presses the tile, and it reverts to false when the tile is released.
  /// It is used to update the tile's appearance in response to user interaction.
  bool pressed = false;

  /// The height of the [_FieldTile] widget.
  ///
  /// This variable is a double that sets the height of the [_FieldTile] widget.
  /// It's used to control the vertical size of the tile, making it adaptable to various
  /// screen sizes and orientations.
  double height = 52;

  /// The [GlobalKey] for the [_FieldTile] widget.
  ///
  /// This key allows for direct control and manipulation of the widget's state
  /// from other parts of the codebase. It provides a way to access the state of
  /// the widget and can be used for triggering state updates, accessing context,
  /// or querying the widget's details.
  GlobalKey key = GlobalKey();

  /// Determines whether the details of the field should be shown.
  ///
  /// This variable is a boolean that controls the visibility of the field's
  /// details in the UI. When set to `true`, the additional details of the
  /// field are displayed to the user. Conversely, when `false`, such details
  /// are hidden, providing a cleaner and more succinct view.
  bool show = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    final bodyMedium = textTheme.bodyMedium;
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final surfaceVariant = colorScheme.surfaceVariant;
    final borderSide = BorderSide(color: surfaceVariant);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: handleTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: widget.bordered ? borderSide : BorderSide.none,
          ),
        ),
        // width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.field.label,
                          style: bodySmall?.copyWith(color: primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          key: key,
                          widget.field.type == 'password' && !show
                              ? '••••••••••••••••'
                              : widget.field.value.runes
                                  .map((code) => String.fromCharCode(code))
                                  .join('\u200B'),
                          style: bodySmall,
                        ),
                        if (widget.field.type == 'password') ...[
                          const SizedBox(height: 4),
                          _Strength(password: widget.field.value)
                        ]
                      ],
                    ),
                  ),
                  if (widget.field.type == 'password')
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: showPassword,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: height - 8 * 2,
                        child: Icon(
                          show
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: primary,
                          size: 16,
                        ),
                      ),
                    )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: copy,
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 150),
                  width: pressed ? 72 : 0,
                  height: height,
                  color: primary,
                  child: Text(
                    '复制',
                    maxLines: 1,
                    style: bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calculates and updates the height of the widget.
  ///
  /// This method calculates the height based on the field type and current context size.
  /// If the field type is 'password', additional height is added. The calculated height
  /// is then set to the `height` state variable.
  void calculateHeight() {
    setState(() {
      height = 8 * 2 + 16 + 4 + key.currentContext!.size!.height;
      if (widget.field.type == 'password') {
        height += 4 + 2 * 2 + 16;
      }
    });
  }

  /// Triggers the copy animation and copies the current field value to the clipboard.
  ///
  /// This method sets the clipboard data with the current field value
  /// and displays a snack bar to confirm that the text has been copied.
  void copy() {
    Clipboard.setData(ClipboardData(text: widget.field.value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('已复制到剪贴板', textAlign: TextAlign.center),
        width: 132,
      ),
    );
    setState(() {
      pressed = !pressed;
    });
  }

  /// Handles the tap event on the copy icon.
  ///
  /// Toggles the `pressed` state to initiate the copy animation and copies the
  /// current field value to the clipboard. After copying, it displays a snack bar
  /// with a confirmation message.
  void handleTap() {
    setState(() {
      pressed = !pressed;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calculateHeight();
    });
  }

  /// Toggles the visibility of the password.
  ///
  /// When invoked, this method updates the `show` state to its opposite value, effectively
  /// toggling the visibility of the password. After the state update, it recalculates
  /// the height. If `show` is `true`, the password will be visible. If `show` is `false`,
  /// the password will be hidden.
  void showPassword() async {
    setState(() {
      show = !show;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calculateHeight();
    });
  }
}

/// [_Indicator] is a StatelessWidget that displays an indicator for the password strength.
///
/// This widget takes a [Guard] object as input, which contains the password
/// that the indicator will represent. The indicator then gives a visual representation
/// of the strength of the password, allowing the user to see how secure their password is.
///
/// If no [Guard] object is provided, or the [Guard] does not contain a password,
/// the widget will not display anything.
class _Indicator extends StatelessWidget {
  /// The [Guard] object associated with this [_Indicator] widget.
  ///
  /// This property holds the [Guard] object that contains the password
  /// which the [_Indicator] widget represents. The [Guard] object provides
  /// the necessary data for the indicator to give a visual representation
  /// of the strength of the password. If no [Guard] object is provided,
  /// or the [Guard] does not contain a password, the widget will not display anything.
  final Guard? guard;

  /// Creates an instance of [_Indicator].
  ///
  /// You can optionally pass a [Guard] object to associate it with this [_Indicator] widget.
  /// If the [Guard] object contains a password, the [_Indicator] widget will display
  /// a visual representation of the strength of the password.
  ///
  /// If no [Guard] object is provided, or the [Guard] does not contain a password,
  /// the widget will not display anything.
  ///
  /// [guard] is a [Guard] object that contains the password for this widget.
  const _Indicator({this.guard});

  @override
  Widget build(BuildContext context) {
    String? password = guard?.password;
    if (password == null) {
      return const SizedBox();
    }
    int level = PasswordGenerator().calculateStrengthLevel(password);
    if (level > 1 || password.isEmpty) {
      return const SizedBox();
    }
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        color: Colors.orange,
      ),
      height: 4,
    );
  }
}

/// The [_IndicatorVariant] widget displays a variant of an indicator for password strength.
///
/// This widget is a variation of the [_Indicator] widget and provides a visual representation
/// of a password's strength using a [Guard] object. If the [Guard] object contains a password,
/// the [_IndicatorVariant] widget will display a visual representation of the strength of the password.
///
/// If no [Guard] object is provided, or the [Guard] does not contain a password,
/// the widget will not display anything.
///
/// [guard] is a [Guard] object that contains the password for this widget.
class _IndicatorVariant extends StatelessWidget {
  /// The [Guard] object associated with this [_IndicatorVariant] widget.
  ///
  /// This property holds the [Guard] object that represents the security context
  /// for the [_IndicatorVariant] widget. The [Guard] object provides the necessary
  /// data for the widget to give a visual representation of the password strength.
  ///
  /// If no [Guard] object is provided, or if the [Guard] does not contain a password,
  /// the widget will not display anything.
  ///
  /// [guard] is a [Guard] object that holds the password and other security context
  /// for this widget.
  final Guard? guard;

  /// Creates an instance of [_IndicatorVariant] widget.
  ///
  /// Takes in a [Guard] object which represents the security context
  /// for the [_IndicatorVariant] widget. The [Guard] object provides
  /// the necessary data for the widget to give a visual representation
  /// of the password strength.
  ///
  /// [guard] is a [Guard] object that holds the password and other
  /// security context for this widget.
  const _IndicatorVariant({this.guard});

  @override
  Widget build(BuildContext context) {
    String? password = guard?.password;
    if (password == null) {
      return const SizedBox();
    }
    int level = PasswordGenerator().calculateStrengthLevel(password);
    if (level > 1 || password.isEmpty) {
      return const SizedBox();
    }
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;
    return Container(
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
    );
  }
}

/// Represents a tile widget displaying information about a [Segment].
///
/// This is a stateless widget that takes a [Segment] object and displays
/// its properties in a tile format. It is used in a list or grid to represent
/// individual segment data visually.
class _SegmentTile extends StatelessWidget {
  /// The [segment] holds the data for a particular segment.
  ///
  /// It contains all the information about a segment, such as its title
  /// and the list of fields within it. This property must be provided
  /// when creating a new [_SegmentTile] and cannot be null.
  final Segment segment;

  /// The [_SegmentTile] widget displays a segment with a title and a list of fields.
  ///
  /// This stateless widget takes a [Segment] object and constructs a tile
  /// that represents the segment's information. The segment's title is displayed
  /// at the top, followed by a list of fields contained within the segment.
  /// Each field is represented as a [_FieldTile].
  ///
  /// Requires a [segment] parameter of type [Segment] to be provided.
  const _SegmentTile({required this.segment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final bodySmall = textTheme.bodySmall;
    final surfaceVariant = colorScheme.surfaceVariant;
    final borderSide = BorderSide(color: surfaceVariant);
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
            style: bodySmall?.copyWith(color: surfaceVariant),
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

class _Strength extends StatelessWidget {
  final String? password;
  const _Strength({this.password});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.red,
      Colors.deepOrange,
      Colors.orange,
      Colors.lightGreen,
      Colors.green,
    ];
    final List<String> levels = [
      '很差',
      '弱',
      '一般',
      '好',
      '非常好',
    ];
    final level = PasswordGenerator().calculateStrengthLevel(password ?? '');

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodySmall = textTheme.bodySmall;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: colors[level],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        levels[level],
        style: bodySmall?.copyWith(color: Colors.white),
      ),
    );
  }
}
