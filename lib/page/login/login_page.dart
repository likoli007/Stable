import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in_platform_interface/src/types.dart';
import 'package:stable/authentication/auth_service.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/page/task/task_view.dart'; // Import TaskView

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = GetIt.instance<AuthService>();

  @override
  void initState() {
    super.initState();
    _auth.googleSignInPlugin.userDataEvents
        ?.listen((GoogleSignInUserData? userData) {
      if (userData != null) {
        _auth.googleAccount = userData;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskView()),
        );
      } else {
        const SnackBar(content: Text('Login failed, please try again'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Login",
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TaskView()),
              );
            },
            child: Text("Skip login"),
          ),
          Container(
            width: 300,
            height: 50,
            child: _auth.googleSignInPlugin.renderButton(
              configuration: GSIButtonConfiguration(
                theme: GSIButtonTheme.filledBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
