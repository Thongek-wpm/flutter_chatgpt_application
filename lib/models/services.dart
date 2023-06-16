import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  googleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> facebookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        print('Facebook Login Successful');
        print('Access Token: ${accessToken.token}');
        final userData = await FacebookAuth.instance.getUserData();
        print('User Data: $userData');
      } else {
        print('Facebook Login Failed');
        print('Status: ${result.status}');
        print('Error Message: ${result.message}');
      }
    } catch (e) {
      print('Facebook Login Error: $e');
    }
  }
}
