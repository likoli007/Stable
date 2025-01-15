import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/page/household/edit_household_page.dart';

import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/ui/page/task/household_task_page.dart';
import 'package:stable/ui/page/household/household_task_history_page.dart';

class HouseholdPage extends StatelessWidget {
  final Household household;

  const HouseholdPage({super.key, required this.household});

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: household.name,
      body: _buildHouseholdOverviewPage(context),
    );
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
        _buildSettingsButton(context),
        const SizedBox(height: STANDARD_GAP),
        _buildTaskOverviewButton(context),
        const SizedBox(height: STANDARD_GAP),
        _buildFailedTasksHistoryButton(context),
        Text("GroupId: ${household.groupId}")
      ],
    );
  }

  Widget _buildButton(String text, Icon icon, Function onPressed) {
    // TODO extract to a common widget
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

  Widget _buildFailedTasksHistoryButton(BuildContext context) {
    return _buildButton('View Failed Tasks', const Icon(Icons.access_time), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HouseholdTaskHistoryPage(
            householdReference: household.id,
          ),
        ),
      );
    });
  }

  Widget _buildSettingsButton(BuildContext context) {
    return _buildButton("Settings", const Icon(Icons.settings), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditHouseholdPage(
            householdReference: household.id,
          ),
        ),
      );
    });
  }
  // TODO only show tasks here
  // TODO SpeedDial with Rename, Manage Inhabitants, Leave, view failed tasks, share invite code
  // TODO add rotary task overview and settings
}
