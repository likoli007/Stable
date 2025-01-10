import 'package:flutter/material.dart';
import 'package:stable/common/util/shared_ui_constants.dart';

import '../../common/widget/page_template.dart';
import '../../model/household/household.dart';
import '../task/household_task_page.dart';

class HouseholdPage extends StatelessWidget {
  final Household household;

  const HouseholdPage({Key? key, required this.household}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: "${household.name} overview",
        child: _buildHouseholdOverviewPage(context));
    // TODO add rotary task overview and settings
    // TODO add unassigned task list (for inhabitants to claim)
    //TODO household management shortcut (only visible to admin)
  }

  Widget _buildHouseholdOverviewPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          household.name,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: STANDARD_GAP),
        _buildSettingsButton(),
        const SizedBox(height: STANDARD_GAP),
        _buildInhabitantsButton(context),
        const SizedBox(height: STANDARD_GAP),
        _buildTaskOverviewButton(context),
        Text("GroupId: ${household.groupId}")
      ],
    );
  }

  Widget _buildButton(String text, Icon icon, Function onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          onPressed.call();
        },
        icon: icon,
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: STANDARD_GAP),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildInhabitantsButton(BuildContext context) {
    return _buildButton("View Inhabitants", const Icon(Icons.accessible), () {
      //TODO: view inhabitants
    });
  }

  Widget _buildTaskOverviewButton(BuildContext context) {
    return _buildButton("View Tasks", const Icon(Icons.task), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HouseholdTaskPage(
            householdReference: household.id,
          ),
        ),
      );
    });
  }

  Widget _buildSettingsButton() {
    return _buildButton("Settings", const Icon(Icons.settings), () {});
  }
}
