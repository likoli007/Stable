import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/page/home/home_page.dart';
import 'package:stable/page/household/household_page.dart';
import 'package:stable/page/login/introduction_page.dart';
import 'package:stable/page/task/task_view.dart';

class AppWrapper extends StatelessWidget {
  AppWrapper({super.key});

  final FirebaseAuthService _auth = GetIt.instance<FirebaseAuthService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors
                  .deepPurple), // TODO change color scheme and introduce dark theme
          useMaterial3: true,
        ),
        initialRoute: _auth.user == null ? '/' : '/home',
        routes: {
          '/': (context) => IntroductionPage(),
          '/home': (context) => HomePage(),
          '/tasks': (context) => TaskView(),
          '/household': (context) => HouseholdPage(),
          //TODO: Add routes
        });
    //TODO: Add responsive design for landscape desktop users
    //TODO: Add theme switcher (and color buttons)
  }
}
