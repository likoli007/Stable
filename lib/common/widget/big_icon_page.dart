import 'package:flutter/material.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/full_width_button.dart';

class BigIconPage extends StatelessWidget {
  final Icon icon;
  final String title;
  final String text;
  final List<Widget> buttons;

  const BigIconPage(
      {super.key,
      required this.icon,
      required this.title,
      required this.text,
      required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Spacer(),
      icon,
      const SizedBox(height: BIG_GAP),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Text(
                title,
                textScaler: const TextScaler.linear(HEADLINE_SCALER),
              ),
              const SizedBox(height: SMALL_GAP),
              Text(
                text,
                textScaler: const TextScaler.linear(INFO_PARAGRAPH_SCALER),
              ),
            ],
          ),
          const SizedBox(height: STANDARD_GAP),
          ...buttons,
        ],
      ),
    ]);
  }
}
