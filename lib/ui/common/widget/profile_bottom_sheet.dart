import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/ui/common/theme/toggle_buttons_theme.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/full_width_button.dart';
import 'package:stable/ui/common/widget/user_profile_picture.dart';
import 'package:stable/service/settings_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:stable/service/inhabitant_service.dart';

class ProfileBottomSheet extends StatelessWidget {
  ProfileBottomSheet({super.key});

  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();
  final _settingsController = GetIt.instance<SettingsController>();
  final _inhabitantService = GetIt.instance<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                const SizedBox(height: STANDARD_GAP),
                _buildColorPickerButton(context),
                const SizedBox(height: STANDARD_GAP),
                _buildThemeModeToggle(context),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        UserProfilePicture(
          size: 100,
          user: FirebaseAuth.instance.currentUser!.uid,
        ),
        const SizedBox(width: STANDARD_GAP),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _auth.userName,
              textScaler: const TextScaler.linear(NAME_SCALER),
            ),
            ElevatedButton.icon(
              label: const Text("Log out"),
              icon: const Icon(Icons.logout, color: Colors.white),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/introduction');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPickerButton(BuildContext context) {
    return FullWidthButton(
      onPressed: () => _showColorPickerDialog(context),
      label: 'Change profile color',
      icon: const Icon(Icons.palette),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    Color selectedColor = Colors.blue; // Default color

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                _changeInhabitantColor(selectedColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeInhabitantColor(Color color) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _inhabitantService.changeInhabitantColor(user.uid, color);
    }
  }

  Widget _buildThemeModeToggle(BuildContext context) {
    final toggleButtonsTheme =
        Theme.of(context).extension<CustomToggleButtonsTheme>();

    return StreamBuilder(
      stream: _settingsController.settingsStream,
      builder: (context, settingsSnapshot) {
        if (settingsSnapshot.hasError) {
          return Text('Error: ${settingsSnapshot.error}');
        }

        if (!settingsSnapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final settings = settingsSnapshot.data!;
        final themeMode = settings.themeMode;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  borderColor: toggleButtonsTheme?.fillColor,
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth / 3 - 3,
                    minHeight: BUTTON_HEIGHT,
                  ),
                  onPressed: (buttonIndex) {
                    if (buttonIndex >= 0 && buttonIndex < THEME_MODES.length) {
                      _settingsController
                          .updateThemeMode(THEME_MODES[buttonIndex]);
                    }
                  },
                  borderRadius: BorderRadius.circular(40),
                  fillColor: toggleButtonsTheme?.fillColor,
                  isSelected:
                      THEME_MODES.map((mode) => themeMode == mode).toList(),
                  children: THEME_MODES.map((mode) {
                    final titleWithIcon = switch (mode) {
                      ThemeMode.system => (
                          title: 'System',
                          icon: Icons.settings
                        ),
                      ThemeMode.dark => (
                          title: 'Dark',
                          icon: Icons.nightlight_round
                        ),
                      ThemeMode.light => (
                          title: 'Light',
                          icon: Icons.wb_sunny,
                        ),
                    };

                    return _buildThemeModeToggleButton(
                      context: context,
                      title: titleWithIcon.title,
                      icon: titleWithIcon.icon,
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildThemeModeToggleButton(
      {required BuildContext context,
      required String title,
      required IconData icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(icon),
        const SizedBox(width: STANDARD_GAP / 2),
        Text(title),
      ],
    );
  }
}
