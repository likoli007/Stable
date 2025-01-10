import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/common/theme/theme_provider.dart';
import 'package:stable/model/settings/settings.dart';
import 'package:stable/page/home/home_page.dart';
import 'package:stable/page/login/introduction_page.dart';
import 'package:stable/page/task/household_task_page.dart';
import 'package:stable/page/task/user_task_page.dart';
import 'package:stable/service/settings_controller.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';

class AppWrapper extends StatelessWidget {
  AppWrapper({super.key});

  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();
  final _settingsController = GetIt.instance<SettingsController>();
  final _themeProvider = GetIt.instance<ThemeProvider>();

  @override
  Widget build(BuildContext context) {
    return LoadingStreamBuilder<Settings>(
      stream: _settingsController.settingsStream,
      builder: _materialAppBuilder,
    );
  }

  Widget _materialAppBuilder(BuildContext context, Settings settings) {
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
        '/tasks': (context) => UserTaskPage(),
        //'/tasks': (context) => HouseholdTaskPage(),
        //TODO '/household': (context) => HouseholdPage(),
        //TODO: Add routes
      },
    );
  }
}
