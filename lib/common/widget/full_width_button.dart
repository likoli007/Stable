import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Icon? icon;
  final Alignment alignment;

  const FullWidthButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon = null,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          alignment: alignment,
        ),
        label: Text(label),
      ),
    );
  }
}
