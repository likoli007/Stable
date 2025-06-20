import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String infoText;
  final String buttonText;
  final int? maxInputLength;
  final String? textFieldInitialValue;
  final Future<void> Function(String name) onSubmit;

  const TextInputDialog({
    super.key,
    required this.title,
    this.infoText = "",
    required this.buttonText,
    this.maxInputLength,
    this.textFieldInitialValue,
    required this.onSubmit,
  });

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

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
                widget.title,
                textScaler: const TextScaler.linear(INFO_PARAGRAPH_SCALER),
              ),
              const SizedBox(height: SMALL_GAP),
              Text(widget.infoText),
              const SizedBox(height: STANDARD_GAP),
              _buildHouseholdNameTextField(),
              const SizedBox(height: STANDARD_GAP),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
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
          onPressed: () async {
            if (_textController.text.trim().isNotEmpty) {
              await widget.onSubmit(_textController.text.trim());
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Heeey, the input field cannot be empty')),
              );
            }
          },
          child: Text(widget.buttonText),
        ),
      ],
    );
  }

  Widget _buildHouseholdNameTextField() {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      maxLength: widget.maxInputLength,
      decoration: InputDecoration(
        labelText: widget.textFieldInitialValue ?? "",
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
