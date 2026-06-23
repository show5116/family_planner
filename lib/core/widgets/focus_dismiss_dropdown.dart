import 'package:flutter/material.dart';

/// Prevents the keyboard from re-appearing after a dropdown is closed.
///
/// Flutter restores focus to the previously focused widget (e.g. a text field)
/// when a dropdown route pops, which re-opens the keyboard on mobile.
/// This wrapper calls [FocusScope.unfocus] on pointer-down so there is no
/// text field to restore focus to after the dropdown closes.
class FocusDismissDropdown extends StatelessWidget {
  final Widget child;

  const FocusDismissDropdown({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
