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

  const PageBody({
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
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          Visibility(
            visible: showProfileButton,
            child: IconButton(
              icon: FirebaseAuth.instance.currentUser != null
                  ? UserProfilePicture(
                      size: 40,
                      user: FirebaseAuth.instance.currentUser!.uid,
                    )
                  : const Icon(Icons.account_circle),
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: PAGE_BODY_MAX_WIDTH),
          padding: const EdgeInsets.all(STANDARD_GAP),
          child: body,
        ),
      ),
    );
  }
}
