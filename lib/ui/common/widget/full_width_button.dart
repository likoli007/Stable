import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';

class FullWidthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Icon? icon;
  final Alignment alignment;

  const FullWidthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SMALL_GAP),
      child: SizedBox(
        width: double.infinity,
        height: BUTTON_HEIGHT,
        child: ElevatedButton.icon(
          icon: icon != null
              ? Icon(icon!.icon, color: Theme.of(context).colorScheme.onPrimary)
              : null,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            alignment: alignment,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
