// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsignin;
import 'package:habited/models/user.model.dart';
import 'package:habited/views/splash_screen.dart';

class AuthRepo {
  static signIn() async {
    try {
      final googleSignIn = gsignin.GoogleSignIn(
        clientId: '691675216102-rn949cv6802m64ok80jtc1cl13mtohf7.apps.googleusercontent.com',
        scopes: <String>['email'],
      );
      final gsignin.GoogleSignInAccount? gsiAccountUser = await googleSignIn.signIn();
      if (gsiAccountUser == null) throw ("gsiAccountUser is null");

      //! below is the code that i am using now
      final gsignin.GoogleSignInAuthentication ga = await gsiAccountUser.authentication;
      var cred = GoogleAuthProvider.credential(accessToken: ga.accessToken, idToken: ga.idToken);
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(cred);
      final User? user = authResult.user;
      if (user == null) return null;
      UserModel.name = user.displayName!;
      UserModel.uid = user.uid;
      UserModel.email = user.email!;
      UserModel.photoUrl = user.photoURL!;
      await UserModel.toPrefs();

      //! below is the code that i was using previously
      // UserModel.name = gsiAccountUser.displayName!;
      // UserModel.uid = gsiAccountUser.id;
      //!

      if (!await isRegistered(UserModel.uid)) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore.collection('users').doc(UserModel.uid).set({
          'name': UserModel.name,
          'email': UserModel.email,
        });
      }
    } catch (e) {
      throw ("error static Future<gsignin.GoogleSignInAccount?> signIn() : $e");
    }
  }

  static Future<void> signOut(context) async {
    await UserModel.reset();
    try {
      await FirebaseAuth.instance.signOut();
      await gsignin.GoogleSignIn().signOut();
    } catch (e) {
      print("error static Future<void> signOut() : $e");
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
  }

  static Future<bool> isRegistered(String uid) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      return firestore.collection('users').doc(uid).get().then((value) => value.exists);
    } catch (e) {
      throw ("error Future<bool> isRegistered(String uid) : $e");
    }
  }

  // Future<fauth.User?> signInWithGoogle() async {
  //   try {
  //     final googleSignIn = gsignin.GoogleSignIn();
  //     fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
  //     final gsignin.GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //     final gsignin.GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

  //     final fauth.AuthCredential credential = fauth.GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     final fauth.UserCredential authResult = await auth.signInWithCredential(credential);
  //     final fauth.User? user = authResult.user;
  //     if (user == null) return null;

  //     print(user.displayName);
  //     print(user.email);
  //     print(user.photoURL);
  //     print(user.uid);
  //     return user;
  //   } catch (e) {
  //     throw ("error Future<fauth.User?> signInWithGoogle() : $e");
  //   }
  // }
}
