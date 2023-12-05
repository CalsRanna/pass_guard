import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class PasswordTile extends StatefulWidget {
  const PasswordTile({
    super.key,
    required this.label,
    this.obscured = false,
    this.obscureText = false,
    required this.text,
  });

  final String label;
  final bool obscured;
  final bool obscureText;
  final String text;

  @override
  State<PasswordTile> createState() => _PasswordTileState();
}

class _PasswordTileState extends State<PasswordTile> {
  Color? color;
  OverlayEntry? entry;
  bool hasOverlay = false;
  LayerLink link = LayerLink();
  late bool obscured;

  @override
  void initState() {
    obscured = widget.obscured;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 18,
      fontWeight: FontWeight.w900,
    );
    const textStyle = TextStyle(fontSize: 16);
    var text = '';
    if (widget.obscureText && obscured == false) {
      for (var i = 0; i < 16; i++) {
        text = '$text· ';
      }
    } else {
      text = widget.text;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: handleTap,
      child: CompositedTransformTarget(
        link: link,
        child: Container(
          color: color,
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: labelStyle),
              Text(text.trim(), style: textStyle),
            ],
          ),
        ),
      ),
    );
  }

  void handleTap() {
    if (!hasOverlay) {
      final overlayEntry = OverlayEntry(
        builder: (context) => UnconstrainedBox(
          child: CompositedTransformFollower(
            link: link,
            followerAnchor: Alignment.bottomCenter,
            showWhenUnlinked: false,
            targetAnchor: Alignment.topCenter,
            offset: const Offset(0, -8),
            child: _ToolBar(
              obscured: obscured,
              obscureText: widget.obscureText,
              onCopied: handleCopied,
              onToggled: handleToggled,
              onZoomed: handleZoomed,
            ),
          ),
        ),
      );
      Overlay.of(context).insert(overlayEntry);
      setState(() {
        color = Colors.grey.withOpacity(0.25);
        entry = overlayEntry;
        hasOverlay = true;
      });
    } else {
      removeOverlayEntry();
    }
  }

  void handleCopied() async {
    await FlutterClipboard.copy(widget.text);
    removeOverlayEntry();
  }

  void handleToggled() {
    setState(() {
      obscured = !obscured;
    });
    removeOverlayEntry();
  }

  void handleZoomed() {
    removeOverlayEntry();
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Text(
            widget.text,
            style: GoogleFonts.sourceCodePro(fontSize: 96),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void removeOverlayEntry() {
    entry?.remove();
    setState(() {
      color = null;
      entry = null;
      hasOverlay = false;
    });
  }
}

class _ToolBar extends StatelessWidget {
  const _ToolBar({
    this.obscured = false,
    this.obscureText = false,
    this.onCopied,
    this.onToggled,
    this.onZoomed,
  });

  final bool obscured;
  final bool obscureText;
  final void Function()? onCopied;
  final void Function()? onToggled;
  final void Function()? onZoomed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              TextButton(onPressed: onCopied, child: const Text('拷贝')),
              if (obscureText)
                TextButton(
                  onPressed: onToggled,
                  child: Text(obscured ? '隐藏' : '显示'),
                ),
              TextButton(onPressed: onZoomed, child: const Text('放大显示')),
            ],
          ),
        ),
      ),
    );
  }
}
