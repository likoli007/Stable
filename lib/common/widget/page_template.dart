import 'package:flutter/material.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/page/profile/profile_settings_page.dart';

class PageTemplate extends StatelessWidget {
  final String title;
  final Widget child;
  final FloatingActionButton? floatingActionButton;
  bool showProfileButton;

  PageTemplate({
    super.key,
    required this.title,
    required this.child,
    FloatingActionButton? this.floatingActionButton,
    bool this.showProfileButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true, actions: [
        showProfileButton
            ? IconButton(
                icon: const Icon(Icons
                    .settings), // TODO change to googleAccount profile picture
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSettingsPage(),
                    ),
                  );
                },
              )
            : Container(),
      ]),
      floatingActionButton: floatingActionButton,
      body: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: child,
      ),
    );
  }
}
