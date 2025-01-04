import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/profile_bottom_sheet.dart';

class PageTemplate extends StatelessWidget {
  final String title;
  final Widget child;
  final FloatingActionButton? floatingActionButton;
  bool showProfileButton;
  bool showBackButton;

  PageTemplate({
    super.key,
    required this.title,
    required this.child,
    FloatingActionButton? this.floatingActionButton,
    bool this.showProfileButton = true,
    bool this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        automaticallyImplyLeading: showBackButton,
        actions: [
          showProfileButton
              ? IconButton(
                  icon: UserAvatar(
                    size: 40,
                    auth: FirebaseAuth.instance,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ProfileBottomSheet();
                      },
                    );
                  },
                )
              : Container(), //TODO is there a better way to hide the profile button?
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: child,
      ),
    );
  }
}
