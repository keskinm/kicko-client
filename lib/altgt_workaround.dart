import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// https://github.com/flutter/flutter/issues/75675
// flutter/engine#25882 should have fixed this issue. Please wait until the engine
// is rolled into the framework, or wait until the next version.
// Since this is a widespread issue I'm gonna leave this issue open until confirmed '
// 'by many. In the mean time, you might workaround this issue by wrapping the root '
// 'of the app with the following widget:


class ShiftRightFixer extends StatefulWidget {
  ShiftRightFixer({required this.child});
  final Widget child;
  @override
  State<StatefulWidget> createState() => _ShiftRightFixerState();
}

class _ShiftRightFixerState extends State<ShiftRightFixer> {
  final FocusNode focus = FocusNode(skipTraversal: true, canRequestFocus: false);
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focus,
      onKey: (_, RawKeyEvent event) {
        return event.physicalKey == PhysicalKeyboardKey.shiftRight ?
        KeyEventResult.handled : KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}
