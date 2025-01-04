import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseAuthService {
  late final User? user;
  late final String userName;

  FirebaseAuthService() {
    // Initialize Firebase Auth providers
    // For Google sign-in, you need to add the client ID to .env file
    // Client ID can be found in the Google Cloud Console
    FirebaseUIAuth.configureProviders([
      GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID']!),
    ]);
    user = FirebaseAuth.instance.currentUser;
    userName = user!.displayName ?? "No name available";
  }
}
