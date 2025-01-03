import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stable/common/widget/page_template.dart';

class ProfileSettingsPage extends StatelessWidget {
  ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Profile Settings',
      showProfileButton: false,
      child: Row(
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

          // TODO add googleAccount profile picture
          // TODO add invite to household button
          // TODO add leave household button
          // TODO add see household statistics button
          // TODO add manage household button if user is admin
          // TODO change theme button with fancy LERP animation
          // TODO popup like in Google apps?
        ],
      ),
    );
  }

  Future<String?> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName;
  }
}
