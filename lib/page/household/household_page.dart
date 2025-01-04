import 'package:flutter/material.dart';

import '../../common/widget/page_template.dart';
import '../../model/household/household.dart';
import '../task/task_page.dart';

class HouseholdPage extends StatelessWidget {
  final Household household;

  const HouseholdPage({Key? key, required this.household}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: "${household.name} overview",
        child: buildHouseholdOverviewPage(context));
    // TODO add rotary task overview and settings
    // TODO add unassigned task list (for inhabitants to claim)
    //TODO invitation system
    //TODO household management shortcut (only visible to admin)
  }

  Widget buildHouseholdOverviewPage(BuildContext context) {
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
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              //TODO: setting page
            },
            icon: const Icon(Icons.settings),
            label: const Text('Settings'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskPage(),
                ),
              );
            },
            icon: const Icon(Icons.task),
            label: const Text('View Tasks'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
