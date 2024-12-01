import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in_platform_interface/src/types.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  final GoogleSignInPlugin googleSignInPlugin = GoogleSignInPlugin();

  AuthService() {
    googleSignInPlugin.initWithParams(SignInInitParameters(
      scopes: ['email', 'profile', 'https://www.googleapis.com/auth/calendar'],
      signInOption: SignInOption.standard,
      clientId: dotenv.env['GOOGLE_CLIENT_ID'],
      forceCodeForRefreshToken: false,
    ));
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signInSilently();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print(e.toString()); // TODO: Handle error
      return null;
    }
  }

  // Sign out
  Future<GoogleSignInAccount?> signOut() async {
    try {
      return await _googleSignIn.signOut();
    } catch (e) {
      print(e.toString()); // TODO: Handle error
      return null;
    }
  }
}
