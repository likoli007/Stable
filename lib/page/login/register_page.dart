import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../../service/inhabitant_service.dart';

class RegisterScreen extends StatelessWidget {
  final _userProvider = GetIt.instance<UserService>();

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID']!),
      ],
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          String? uid = FirebaseAuth.instance.currentUser?.uid;
          String? displayName = FirebaseAuth.instance.currentUser?.displayName;
          if (uid != null && displayName != null) {
            _userProvider.createInhabitantFromAuth(
                displayName: displayName, uid: uid);
          } else {
            //TODO: error handling? can this even occur?
          }
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          //Registered user get an UID assigned by firestore auth, we need it inside our db

          Navigator.pushReplacementNamed(context, '/home');
        }),
      ],
    );
    // TODO Preserve the user after closing the app
  }
}
