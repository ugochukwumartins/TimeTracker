import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:time_tracking_app/Services/Auth.dart';

class SignInBloc {
  final AuthBase auth;
  final ValueNotifier<bool> isLoadig;

  SignInBloc({@required this.isLoadig, @required this.auth});

  Future<User> _singin(Future<User> Function() signInMethod) async {
    try {
      isLoadig.value = true;
      return await signInMethod();
    } catch (e) {
      isLoadig.value = false;

      rethrow;
    }
  }

  Future<User> singinAnonimously() async => _singin(auth.singinAnonimously);
  Future<User> singinWithFacebook() async => _singin(auth.singinWithFacebook);
  Future<User> singinWithGoogle() async => _singin(auth.singinWithGoogle);
}
