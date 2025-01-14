// lib/common/page/page_layout.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/bottom_navigation.dart';
import 'package:stable/common/widget/profile_bottom_sheet.dart';
import 'package:stable/common/widget/user_profile_picture.dart';

class PageLayout extends StatefulWidget {
  final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final bool showProfileButton;
  final bool showBackButton;

  PageLayout({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.showProfileButton = true,
    this.showBackButton = true,
  });

  @override
  _PageLayoutState createState() => _PageLayoutState();

  void update(
      {required String title,
      required Widget body,
      FloatingActionButton? floatingActionButton}) {
    _PageLayoutState? state = _PageLayoutState();
    state.update(
      title: title,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _PageLayoutState extends State<PageLayout> {
  late String _title;
  late Widget _body;
  FloatingActionButton? _floatingActionButton;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _body = widget.body;
    _floatingActionButton = widget.floatingActionButton;
  }

  void update(
      {required String title,
      required Widget body,
      FloatingActionButton? floatingActionButton}) {
    if (mounted) {
      setState(() {
        _title = title;
        _body = body;
        _floatingActionButton = floatingActionButton;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        automaticallyImplyLeading: widget.showBackButton,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Visibility(
            visible: widget.showProfileButton,
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
      floatingActionButton: _floatingActionButton,
      body: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: _body,
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
