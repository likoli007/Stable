import 'package:flutter/material.dart';
import 'package:stable/page/home/home_page.dart';
import 'package:stable/page/household/household_page.dart';
import 'package:stable/page/login/introduction_page.dart';
import 'package:stable/page/task/task_page.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

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
        initialRoute: '/',
        routes: {
          '/': (context) => IntroductionPage(),
          '/home': (context) => HomePage(),
          '/tasks': (context) => TaskPage(),
          '/household': (context) => HouseholdPage(),
          //TODO: Add routes
        });
  }
}
