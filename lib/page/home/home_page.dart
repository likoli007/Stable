import 'package:flutter/material.dart';
import 'package:stable/common/widget/page_template.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Household Name Placeholder",
      showBackButton: false,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/tasks');
        },
        child: Text("Tasks"),
      ),
    );
    // TODO add welcome message
    // TODO add an overview of the household (unfinished repeating tasks, rotary tasks)
    // TODO add a center floating button to quickly add a new task
    // TODO add bottom navbar with home/overview, tasklist and household (on web combine it with the appbar)
  }
}
