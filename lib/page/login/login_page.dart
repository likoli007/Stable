import 'package:flutter/material.dart';
import 'package:stable/page/household/edit_household_page.dart';
import 'package:stable/page/task/task_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditHouseholdPage()),
            );
          },
          child: const Text('Create household'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskView()),
            );
          },
          child: const Text('View tasks'),
        ),
      ]),
    );
  }
}
