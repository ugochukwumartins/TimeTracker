import 'package:flutter/foundation.dart';
import 'package:time_tracking_app/Services/Auth.dart';

import 'Validator.dart';
import 'email_sigin_model.dart';

class EmailSigninChangedModel with emailandPasswordValidator, ChangeNotifier {
  EmailSigninChangedModel({
    @required this.auth,
    this.email = " ",
    this.password = " ",
    this.emailSignInFormType = EmailSignInFormType.signIn,
    this.isloading = false,
    this.submited = false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType emailSignInFormType;
  bool isloading;
  bool submited;
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isloading,
    bool submited,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.emailSignInFormType = formType ?? this.emailSignInFormType;
    this.isloading = isloading ?? this.isloading;
    this.submited = submited ?? this.submited;
    notifyListeners();
  }

  void Toggle() {
    final formtype = this.emailSignInFormType == EmailSignInFormType.signIn
        ? EmailSignInFormType.Register
        : EmailSignInFormType.signIn;
    updateWith(
      email: " ",
      password: " ",
      formType: formtype,
      submited: false,
      isloading: false,
    );
  }

  Future<void> signIn() async {
    updateWith(isloading: true, submited: true);
    try {
      if (emailSignInFormType == EmailSignInFormType.signIn) {
        await auth.singinWithEmail(email, password);
      } else {
        await auth.singinCreateAccountWithEmail(email, password);
      }
    } catch (e) {
      updateWith(isloading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  String get Primary {
    return emailSignInFormType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create an Account";
  }

  String get Secondary {
    return emailSignInFormType == EmailSignInFormType.signIn
        ? "Need an Account ? Register"
        : "Have an Account ? Sign in";
  }

  bool get cansubmit {
    return emailvalidator.Isvalid(email) &&
        passwordvalidator.Isvalid(password) &&
        !isloading;
  }

  String get PasswordErroText {
    bool passswordvalid = submited && !passwordvalidator.Isvalid(password);
    return passswordvalid ? passwordError : null;
  }

  String get EmailErroText {
    bool emailvalid = submited && !emailvalidator.Isvalid(email);
    return emailvalid ? emailError : null;
  }
}
