import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/full_width_button.dart';

class ProfileBottomSheet extends StatelessWidget {
  ProfileBottomSheet({Key? key}) : super(key: key);
  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(STANDARD_GAP),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(children: [
                Row(
                  children: [
                    UserAvatar(
                      size: 100,
                      auth: FirebaseAuth.instance,
                    ),
                    SizedBox(width: STANDARD_GAP),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _auth.userName,
                          textScaler: TextScaler.linear(NAME_SCALER),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          icon: Icon(Icons.logout, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          label: Text("Log out"),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: STANDARD_GAP),
                FullWidthButton(
                  label: "Household statistics",
                  icon: Icon(Icons.bar_chart),
                  onPressed: () {
                    //TODO implement household statistics
                  },
                ),
                FullWidthButton(
                  label: "Invite to household",
                  icon: Icon(Icons.person_add_alt_1),
                  onPressed: () {
                    //TODO implement invitation system
                  },
                ),
                FullWidthButton(
                  label: "Manage household",
                  icon: Icon(Icons.manage_accounts),
                  onPressed: () {
                    //TODO implement household management (only visible to admin)
                  },
                ),
                FullWidthButton(
                  label: "Leave household",
                  icon: Icon(Icons.no_meeting_room),
                  onPressed: () {
                    //TODO implement leaving household
                  },
                ),
                SizedBox(height: STANDARD_GAP),
                FullWidthButton(
                  label: "Change theme",
                  icon: Icon(Icons.color_lens),
                  onPressed: () {
                    // TODO change theme button with fancy LERP animation
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
