import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

abstract class AuthBase {
  User get currentUser;
  Stream<User> authchanges();
  Future<User> singinAnonimously();
  Future<User> singinWithFacebook();
  Future<User> singinWithGoogle();
  Future<User> singinWithEmail(String email, String password);
  Future<User> singinCreateAccountWithEmail(String email, String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  Stream<User> authchanges() => _firebaseAuth.authStateChanges();
  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> singinAnonimously() async {
    final currentCredential = await _firebaseAuth.signInAnonymously();
    return currentCredential.user;
  }

  @override
  Future<User> singinWithEmail(String email, String password) async {
    final usercredential =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return usercredential.user;
  }

  @override
  Future<User> singinCreateAccountWithEmail(
      String email, String password) async {
    final usercredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return usercredential.user;
  }

  @override
  Future<User> singinWithGoogle() async {
    final googleSignin = GoogleSignIn();
    final googleUser = await googleSignin.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final usercredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return usercredential.user;
      } else {
        throw FirebaseAuthException(
          code: "Error_aborted_by_user",
          message: "Sign in aborted by user",
        );
      }
    } else {
      throw FirebaseAuthException(
        code: "Error_aborted_by_user",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<User> singinWithFacebook() async {
    final facebook = FacebookLogin();
    final response = await facebook.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.Success:
        final accestoken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accestoken.token),
        );
        return userCredential.user;
      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(
          code: "Error_aborted_by_user",
          message: "Sign in aborted by user",
        );

      case FacebookLoginStatus.Error:
        throw FirebaseAuthException(
          code: "Error facebook login failed",
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignin = GoogleSignIn();
    final facebookLogin = FacebookLogin();
    facebookLogin.logOut();
    await googleSignin.signOut();
    await _firebaseAuth.signOut();
  }
}
