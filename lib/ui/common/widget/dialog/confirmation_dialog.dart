import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String buttonText;
  final Color? confirmButtonForegroundColor;
  final Color? confirmButtonBackgroundColor;
  final Function() onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.children,
    required this.buttonText,
    this.confirmButtonForegroundColor,
    this.confirmButtonBackgroundColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: Container(
          constraints: const BoxConstraints(maxWidth: PAGE_BODY_MAX_WIDTH / 2),
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
      ),
    );
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
            backgroundColor: confirmButtonBackgroundColor ??
                Theme.of(context).colorScheme.primary,
            foregroundColor: confirmButtonForegroundColor ??
                Theme.of(context).colorScheme.onPrimary,
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
