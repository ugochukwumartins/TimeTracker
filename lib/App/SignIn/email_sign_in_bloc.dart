import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:time_tracking_app/Services/Auth.dart';

import 'email_sigin_model.dart';

class EmailSignInBloc {
  final AuthBase auth;
  final StreamController<EmailSigninModel> _modelController =
      StreamController<EmailSigninModel>();

  EmailSignInBloc({@required this.auth});

  Stream<EmailSigninModel> get modelStream => _modelController.stream;
  EmailSigninModel _model = new EmailSigninModel();
  void dispose() {
    _modelController.close();
  }

  Future<void> signIn() async {
    update(isloading: true, submited: true);
    try {
      if (_model.emailSignInFormType == EmailSignInFormType.signIn) {
        await auth.singinWithEmail(_model.email, _model.password);
      } else {
        await auth.singinCreateAccountWithEmail(_model.email, _model.password);
      }
    } catch (e) {
      update(isloading: false);
      rethrow;
    }
  }

  void Toggle() {
    final formtype = _model.emailSignInFormType == EmailSignInFormType.signIn
        ? EmailSignInFormType.Register
        : EmailSignInFormType.signIn;
    update(
      email: " ",
      password: " ",
      formType: formtype,
      submited: false,
      isloading: false,
    );
  }

  void updateEmail(String email) => update(email: email);
  void updatePassword(String password) => update(password: password);
  void update({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isloading,
    bool submited,
  }) {
    _model = _model.copy(
      email: email,
      password: password,
      formType: formType,
      isloading: isloading,
      submited: submited,
    );
    _modelController.add(_model);
  }
}
