import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String buttonText;
  final Function() onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.children,
    required this.buttonText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textScaler: const TextScaler.linear(INFO_PARAGRAPH_SCALER),
            ),
            const SizedBox(height: SMALL_GAP),
            ...children,
            const SizedBox(height: STANDARD_GAP),
            _buildButtons(context),
          ],
        ),
      ),
    );
    ;
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
