import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:time_tracking_app/Services/Auth.dart';

class SignInBloc {
  final AuthBase auth;
  StreamController<bool> _isloadingController = new StreamController<bool>();

  SignInBloc({@required this.auth});
  Stream<bool> get isloadingStream => _isloadingController.stream;
  void dispose() {
    _isloadingController.close();
  }

  void _setIsloading(bool isLoading) => _isloadingController.add(isLoading);
  Future<User> _singin(Future<User> Function() signInMethod) async {
    try {
      _setIsloading(true);
      return await signInMethod();
    } catch (e) {
      _setIsloading(false);

      rethrow;
    }
  }

  Future<User> singinAnonimously() async => _singin(auth.singinAnonimously);
  Future<User> singinWithFacebook() async => _singin(auth.singinWithFacebook);
  Future<User> singinWithGoogle() async => _singin(auth.singinWithGoogle);
}
