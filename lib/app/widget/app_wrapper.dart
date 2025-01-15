import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/ui/common/page/page_layout.dart';
import 'package:stable/model/settings/settings.dart';
import 'package:stable/ui/page/login/introduction_page.dart';
import 'package:stable/ui/page/task/user_task_page.dart';
import 'package:stable/service/settings_controller.dart';
import 'package:stable/ui/common/widget/loading_stream_builder.dart';
import 'package:stable/ui/common/theme/app_theme_data.dart';

class AppWrapper extends StatelessWidget {
  AppWrapper({
    Key? key,
    required this.lightThemeData,
    required this.darkThemeData,
  }) : super(key: key);

  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();
  final _settingsController = GetIt.instance<SettingsController>();

  final AppThemeData lightThemeData;
  final AppThemeData darkThemeData;

  @override
  Widget build(BuildContext context) {
    return LoadingStreamBuilder<Settings>(
      stream: _settingsController.settingsStream,
      builder: _materialAppBuilder,
    );
  }

  Widget _materialAppBuilder(BuildContext context, Settings settings) {
    final materialApp = MaterialApp(
      title: 'Stable',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: lightThemeData.materialThemeData,
      darkTheme: darkThemeData.materialThemeData,
      initialRoute: _auth.user != null ? '/' : '/introduction',
      routes: {
        '/introduction': (context) => IntroductionPage(),
        '/': (context) => PageLayout(),
        '/tasks': (context) => UserTaskPage(),
        //'/tasks': (context) => HouseholdTaskPage(),
        //TODO '/household': (context) => HouseholdPage(),
        //TODO: Add routes
      },
    );
    return materialApp;
  }
}
