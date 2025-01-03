import 'package:flutter/material.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/page/login/register_page.dart';
import 'package:stable/page/task/task_view.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Welcome to the Stable!",
      showProfileButton: false,
      child: Column(
        children: [
          // TODO Add introduction to the app
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TaskView()),
              );
            },
            child: Text("Skip login"), // TODO Remove this button
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: Text('Register with OAuth'),
          )
        ],
      ),
    );
  }
}
