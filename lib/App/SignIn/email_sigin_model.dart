enum EmailSignInFormType {
  signIn,
  Register,
}

class EmailSigninModel {
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
}
