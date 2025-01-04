import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/common/util/shared_ui_constants.dart';

class ProfileBottomSheet extends StatelessWidget {
  ProfileBottomSheet({Key? key}) : super(key: key);
  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(
            size: 100,
            auth: FirebaseAuth.instance,
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text("Log out"),
          ),
          Text(_auth.userName),
          ElevatedButton(
            onPressed: () {
              //TODO implement invitation system
            },
            child: const Text("Invite to household"),
          ),
          ElevatedButton(
            onPressed: () {
              //TODO implement leaving household
            },
            child: const Text("Leave household"),
          ),
          ElevatedButton(
            onPressed: () {
              //TODO implement household statistics
            },
            child: const Text("See full household statistics"),
          ),
          ElevatedButton(
            onPressed: () {
              //TODO implement household management (only visible to admin)
            },
            child: const Text("Manage household"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO change theme button with fancy LERP animation
            },
            child: const Text("Change theme"),
          ),
          const SizedBox(width: STANDARD_GAP),
        ],
      ),
    );
  }
}
