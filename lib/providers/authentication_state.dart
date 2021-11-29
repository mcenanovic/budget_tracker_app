import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationState extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  AuthenticationState() {
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp();

    // FirebaseAuth.instance.userChanges().listen((user) {
    //   if (user != null) {
    //     // print(user);
    //   } else {
    //     print('NO USER');
    //   }
    //   notifyListeners();
    // });
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> registerAccount(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithGoogle() async {
    final response = await _googleSignIn.signIn();

    if (response == null) {
      return;
    }

    final googleAuth = await response.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithFacebook() async {
    final fb = FacebookLogin();
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = res.accessToken;
        final AuthCredential authCredential =
            FacebookAuthProvider.credential(res.accessToken!.token);

        try {
          await FirebaseAuth.instance.signInWithCredential(authCredential);
        } on FirebaseAuthException catch (e) {
          throw e;
        }

        break;
      case FacebookLoginStatus.cancel:
        print('There was a cancel!');
        break;
      case FacebookLoginStatus.error:
        print('There was an error!');
        break;
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
