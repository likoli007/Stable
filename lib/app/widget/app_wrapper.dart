import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/common/theme/theme_provider.dart';
import 'package:stable/page/home/home_page.dart';
import 'package:stable/page/household/household_page.dart';
import 'package:stable/page/login/introduction_page.dart';
import 'package:stable/page/task/task_page.dart';
import 'package:stable/service/settings_controller.dart';

class AppWrapper extends StatelessWidget {
  AppWrapper({super.key});

  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();
  final _settingsController = GetIt.instance<SettingsController>();
  final _themeProvider = GetIt.instance<ThemeProvider>();

  @override
  Widget build(BuildContext context) {
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

          return MaterialApp(
              title: 'Stable',
              debugShowCheckedModeBanner: false,
              themeMode: settings.themeMode,
              theme: _themeProvider.themeSeeded(
                seedColor: settings.themeColor,
              ),
              darkTheme: _themeProvider.themeSeeded(
                seedColor: settings.themeColor,
                brightness: Brightness.dark,
              ),
              initialRoute: _auth.user == null ? '/' : '/home',
              routes: {
                '/': (context) => IntroductionPage(),
                '/home': (context) => HomePage(),
                '/tasks': (context) => TaskPage(),
                //TODO '/household': (context) => HouseholdPage(),
                //TODO: Add routes
              });
          //TODO: Add responsive design for landscape desktop users
          //TODO: Add theme switcher (and color buttons)
        });
  }
}
