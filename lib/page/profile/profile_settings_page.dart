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
                Navigator.pushReplacementNamed(
                    context, '/'); // TODO remove the option to get back
              },
              child: const Text("Log out")),
          FutureBuilder<String?>(
            // TODO rewrite with loading stream builder
            future: _auth.getUserName(),
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
}
