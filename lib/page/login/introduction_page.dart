import 'package:flutter/material.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/full_width_button.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/page/login/register_page.dart';
import 'package:stable/page/task/task_view.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: "Welcome to the Stable!",
        showProfileButton: false,
        showBackButton: false,
        child: Column(children: [
          // TODO Add introduction to the app
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TaskView()),
              );
            },
            child: Text(
                "Skip login (TEMP BUTTON, DELETE!)"), // TODO Remove this button
          ),
          Spacer(),
          //TODO Add image of a stable
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  SizedBox(height: STANDARD_GAP),
                  Text(
                    "Household tasks? No problem.",
                    textScaler: TextScaler.linear(HEADLINE_SCALER),
                  ),
                  Text(
                    "Dirty dishes, laundry, or piled-up trash? "
                    "Create tasks, assign them to your household members, and keep track of their progress. "
                    "Just sit back and relax — Stable will take care of the rest.",
                    textScaler: TextScaler.linear(INFO_PARAGRAPH_SCALER),
                  ),
                ],
              ),
              SizedBox(height: STANDARD_GAP),
              SizedBox(
                width: double.infinity,
                child: FullWidthButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  icon: Icon(Icons.bedroom_baby),
                  label: "Enter the Stable",
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ]));
  }
}
