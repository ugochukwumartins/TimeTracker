import 'Validator.dart';

enum EmailSignInFormType {
  signIn,
  Register,
}

class EmailSigninModel with emailandPasswordValidator {
  EmailSigninModel({
    this.email = " ",
    this.password = " ",
    this.emailSignInFormType = EmailSignInFormType.signIn,
    this.isloading = false,
    this.submited = false,
  });
  final String email;
  final String password;
  final EmailSignInFormType emailSignInFormType;
  final bool isloading;
  final bool submited;
  EmailSigninModel copy({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isloading,
    bool submited,
  }) {
    return EmailSigninModel(
      email: email ?? this.email,
      password: password ?? this.password,
      emailSignInFormType: formType ?? this.emailSignInFormType,
      isloading: isloading ?? this.isloading,
      submited: submited ?? this.submited,
    );
  }

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
