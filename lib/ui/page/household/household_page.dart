import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/speed_dial/custom_speed_dial_child.dart';
import 'package:stable/ui/common/widget/speed_dial/speed_dials.dart';
import 'package:stable/ui/page/household/manage_household_inhabitants.dart';

import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/ui/page/household/share_household_page.dart';
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
      floatingActionButton: _buildSpeedDials(context),
    );
  }

  Widget _buildSpeedDials(BuildContext context) {
    return SpeedDials(
      icon: Icons.more_horiz,
      activeIcon: Icons.more_vert,
      children: [
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.add_task),
          label: 'Add a new task',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onTap: () => {},
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.cancel),
          label: 'View failed tasks',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HouseholdTaskHistoryPage(
                householdReference: household.id,
              ),
            ),
          ),
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.add_reaction),
          label: 'Invite your friend',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShareHouseholdPage(
                groupId: household.id,
              ),
            ),
          ),
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.supervised_user_circle),
          label: 'Manage inhabitants',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageHouseholdInhabitants(
                householdReference: household.id,
              ),
            ),
          ),
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.drive_file_rename_outline_rounded),
          label: 'Rename',
          onTap: () {}, // TODO dialog
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.logout),
          label: 'Leave',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          onTap: () {}, //TODO dialog - are you sure?
        ),
      ],
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
        const SizedBox(height: STANDARD_GAP),
        _buildTaskOverviewButton(context),
        const SizedBox(height: STANDARD_GAP),
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

  // TODO only show tasks here
  // TODO add rotary task overview and settings
  // TODO if no tasks, show a message, how to create a first one, bigIconPage
}
