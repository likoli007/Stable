import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class ProfileBottomSheet extends StatelessWidget {
  ProfileBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          FutureBuilder<String?>(
            future: _fetchUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Text(snapshot.data ?? 'Error');
              } else {
                return Text('No name');
              }
            },
          ),
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
        ],
      ),
    );
  }

  Future<String?> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName; //TODO refactor to auth class
  }
}
