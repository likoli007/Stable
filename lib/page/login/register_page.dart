import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/util/shared_ui_constants.dart';

import '../../service/inhabitant_service.dart';

class RegisterScreen extends StatelessWidget {
  final _userProvider = GetIt.instance<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      subtitleBuilder: (context, action) => _buildIntroductionText(),
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
          }
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushReplacementNamed(context, '/');
        }),
      ],
    );
  }

  Widget _buildIntroductionText() {
    return const Column(
      children: [
        Icon(Icons.face_2, size: 200),
        SizedBox(height: STANDARD_GAP),
        Text(
          "You're just one step away!",
          textScaler: TextScaler.linear(HEADLINE_SCALER),
        ),
        SizedBox(height: SMALL_GAP),
        Text(
          "In order to assign your work to your roommates, we need to know who you are. "
          "Please, sign in with your Google account.",
          textScaler: TextScaler.linear(INFO_PARAGRAPH_SCALER),
        ),
        SizedBox(height: STANDARD_GAP),
      ],
    );
  }
}
