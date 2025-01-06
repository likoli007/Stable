import 'package:flutter/material.dart';

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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon,
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
    );
  }
}
