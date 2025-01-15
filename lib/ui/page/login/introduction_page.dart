import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/big_icon_page.dart';
import 'package:stable/ui/common/widget/full_width_button.dart';
import 'package:stable/ui/page/login/register_page.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(STANDARD_GAP),
            child: BigIconPage(
              icon: const Icon(Icons.bedroom_baby, size: 300),
              title: "Household tasks? No problem.",
              text: "Dirty dishes, laundry, or piled-up trash? "
                  "Create tasks, assign them to your household members, and keep track of their progress. "
                  "Just sit back and relax — Stable will take care of the rest.",
              buttons: [
                FullWidthButton(
                  icon: const Icon(Icons.bedroom_baby),
                  label: "Enter the Stable",
                  alignment: Alignment.center,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen())),
                ),
              ],
            )));
  }
}
