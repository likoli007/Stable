import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stable/page/login/login_page.dart';
import 'package:stable/page/task/task_view.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => TaskView(),
          //TODO: Add routes
        });
  }
}
