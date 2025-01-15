import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/profile_bottom_sheet.dart';
import 'package:stable/ui/common/widget/user_profile_picture.dart';

class PageBody extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final bool showProfileButton;
  final bool showBackButton;

  PageBody({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.showProfileButton = true,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
        centerTitle: true,
        automaticallyImplyLeading: showBackButton,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Visibility(
            visible: showProfileButton,
            child: IconButton(
              icon: FirebaseAuth.instance.currentUser != null
                  ? UserProfilePicture(
                      size: 40,
                      user: FirebaseAuth.instance.currentUser!.uid,
                    )
                  : Icon(Icons.account_circle),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ProfileBottomSheet();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: body,
      ),
    );
  }
}
