import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/authentication/auth_service.dart';
import 'package:stable/common/widget/page_template.dart';

class ProfileSettingsPage extends StatelessWidget {
  ProfileSettingsPage({Key? key}) : super(key: key);

  final AuthService _auth = GetIt.instance<AuthService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Profile Settings',
      child: Row(
        children: [
          ElevatedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text("Log out")),
        ],
      ),
    );
  }
}
