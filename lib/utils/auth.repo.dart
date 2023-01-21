// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:google_sign_in/google_sign_in.dart' as gsignin;

class AuthRepo {
  static Future<gsignin.GoogleSignInAccount?> signIn() async {
    try {
      final googleSignIn = gsignin.GoogleSignIn(
        clientId: '691675216102-rn949cv6802m64ok80jtc1cl13mtohf7.apps.googleusercontent.com',
        scopes: <String>['email'],
      );
      final gsignin.GoogleSignInAccount? gsiAccountUser = await googleSignIn.signIn();
      if (gsiAccountUser == null) return null;
      print(gsiAccountUser.displayName);
      print(gsiAccountUser.email);
      print(gsiAccountUser.photoUrl);
      print(gsiAccountUser.id);
      print(gsiAccountUser.authentication);
      print(gsiAccountUser.authentication.then((value) => value.accessToken));
      print(gsiAccountUser.authentication.then((value) => value.idToken));
      return gsiAccountUser;
    } catch (e) {
      throw ("error static Future<gsignin.GoogleSignInAccount?> signIn() : $e");
    }
  }

  static Future<void> signOut() async {
    try {
      final googleSignIn = gsignin.GoogleSignIn();
      await googleSignIn.signOut();
    } catch (e) {
      throw ("error static Future<void> signOut() : $e");
    }
  }

  Future<fauth.User?> signInWithGoogle() async {
    try {
      final googleSignIn = gsignin.GoogleSignIn();
      fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
      final gsignin.GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final gsignin.GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final fauth.AuthCredential credential = fauth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final fauth.UserCredential authResult = await auth.signInWithCredential(credential);
      final fauth.User? user = authResult.user;
      if (user == null) return null;

      print(user.displayName);
      print(user.email);
      print(user.photoURL);
      print(user.uid);
      return user;
    } catch (e) {
      throw ("error Future<fauth.User?> signInWithGoogle() : $e");
    }
  }
}
