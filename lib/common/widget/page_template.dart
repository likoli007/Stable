import 'package:flutter/material.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/page/profile/profile_settings_page.dart';

class PageTemplate extends StatelessWidget {
  final String title;
  final Widget child;

  const PageTemplate({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true, actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSettingsPage(),
              ),
            );
          },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: child,
      ),
    );
  }
}
