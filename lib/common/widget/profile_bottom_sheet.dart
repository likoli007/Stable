import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/common/theme/toggle_buttons_theme.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/full_width_button.dart';
import 'package:stable/common/widget/user_profile_picture.dart';
import 'package:stable/service/settings_controller.dart';

class ProfileBottomSheet extends StatelessWidget {
  ProfileBottomSheet({Key? key}) : super(key: key);
  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();
  final _settingsController = GetIt.instance<SettingsController>();

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
                _buildProfileSection(context),
                SizedBox(height: STANDARD_GAP),
                _buildHouseholdButtonsSection(),
                SizedBox(height: STANDARD_GAP),
                _buildThemeModeToggleButtons(context),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Row(
      children: [
        UserProfilePicture(
          size: 100,
          user: FirebaseAuth.instance.currentUser!.uid,
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
                backgroundColor: WidgetStateProperty.all(Colors.red),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              label: Text("Log out"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHouseholdButtonsSection() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildThemeModeToggleButtons(BuildContext context) {
    final toggleButtonsTheme =
        Theme.of(context).extension<CustomToggleButtonsTheme>();

    return StreamBuilder(
      stream: _settingsController.settingsStream,
      builder: (context, settingsSnapshot) {
        if (settingsSnapshot.hasError) {
          return Text('Error: ${settingsSnapshot.error}');
        }

        if (!settingsSnapshot.hasData) {
          return CircularProgressIndicator();
        }

        final settings = settingsSnapshot.data!;
        final themeMode = settings.themeMode;

        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              ToggleButtons(
                onPressed: (buttonIndex) {
                  if (buttonIndex >= 0 && buttonIndex < THEME_MODES.length) {
                    _settingsController
                        .updateThemeMode(THEME_MODES[buttonIndex]);
                  }
                },
                borderRadius: toggleButtonsTheme?.borderRadius,
                selectedBorderColor: toggleButtonsTheme?.selectedBorderColor,
                fillColor: toggleButtonsTheme?.fillColor,
                isSelected:
                    THEME_MODES.map((mode) => themeMode == mode).toList(),
                children: THEME_MODES.map((mode) {
                  final titleWithIcon = switch (mode) {
                    ThemeMode.system => (title: 'System', icon: Icons.settings),
                    ThemeMode.dark => (
                        title: 'Dark',
                        icon: Icons.nightlight_round
                      ),
                    ThemeMode.light => (title: 'Light', icon: Icons.wb_sunny),
                  };

                  return _buildThemeModeToggleButton(
                    context: context,
                    title: titleWithIcon.title,
                    icon: titleWithIcon.icon,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeModeToggleButton(
      {required BuildContext context,
      required String title,
      required IconData icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width - 2 * STANDARD_GAP) /
              14), // TODO Rewrite for screen width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon),
          SizedBox(width: STANDARD_GAP / 2),
          Text(title),
        ],
      ),
    );
  }
}
