import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in_platform_interface/src/types.dart';

class AuthService {
  late GoogleSignInUserData? googleAccount;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  final GoogleSignInPlugin googleSignInPlugin = GoogleSignInPlugin();

  AuthService() {
    googleSignInPlugin.initWithParams(SignInInitParameters(
      scopes: [
        'email',
        'profile',
        'https://www.googleapis.com/auth/calendar', // For future use of adding tasks to Google Calendar
      ],
      signInOption: SignInOption.standard,
      clientId: dotenv.env['GOOGLE_CLIENT_ID'],
      forceCodeForRefreshToken: false,
    ));
  }

  Future<GoogleSignInAccount?> signOut() async {
    try {
      googleAccount = null; // Clear the current user
      return await _googleSignIn.signOut();
    } catch (e) {
      print(e.toString()); // TODO: Handle error
      return null;
    }
  }

  Future<String?> getUserName() async {
    print('Google User: $googleAccount'); // Debug print
    return googleAccount?.displayName;
  }

  Future<String?> getUserProfilePicture() async {
    return googleAccount?.photoUrl;
  }
}
