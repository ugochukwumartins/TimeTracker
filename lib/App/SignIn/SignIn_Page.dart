import 'package:flutter/material.dart';
import 'package:time_tracking_app/App/SignIn/sign_in_bloc.dart';

import 'package:time_tracking_app/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/SignUpButtons/raiseButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_tracking_app/common/Showexception.dart';

import 'EmailsignInPage.dart';
import 'SigninPageEmail.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;
  final bool isloading;
  const SignInPage({Key key, @required this.bloc, this.isloading})
      : super(key: key);
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isloading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoadig: isloading),
          child: Consumer<SignInBloc>(
            builder: (_, bloc, __) => SignInPage(
              bloc: bloc,
              isloading: isloading.value,
            ),
          ),
        ),
      ),
    );
  }

  void showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == "Error_aborted_by_user") {
      return;
    }
    Showexception(
      context,
      title: "Sign In Failed",
      exception: exception,
    );
  }

  Future<void> _singInAnonymously(BuildContext context) async {
    try {
      final user = await bloc.singinAnonimously();
    } on Exception catch (e) {
      showSignInError(context, e);
    }
  }

  Future<void> _singInWithGoogle(BuildContext context) async {
    try {
      final user = await bloc.singinWithGoogle();
    } on Exception catch (e) {
      showSignInError(context, e);
    }
  }

  void SignInwithEmail(BuildContext context) {
    try {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => EmailSignInPage(),
        ),
      );
    } on Exception catch (e) {
      showSignInError(context, e);
    }
  }

  Future<void> _singInWithFacebook(BuildContext context) async {
    try {
      final user = await bloc.singinWithFacebook();
    } on Exception catch (e) {
      showSignInError(context, e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Time Tracker"),
        ),
        body: _buildContainer(context));
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: _SignInIdicator(),
          ),
          SizedBox(
            height: 48,
          ),
          buildRaisedButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset("images/google-logo.png"),
                  Text("Sign In With Google"),
                  Opacity(
                    opacity: 0,
                    child: Image.asset("images/facebook-logo.png"),
                  )
                ]),
            borderRadious: 18,
            fontsize: 15,
            TextColor: Colors.black,
            color: Colors.white,
            onpressed: isloading ? null : () => _singInWithGoogle(context),
          ),
          SizedBox(
            height: 10,
          ),
          buildRaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset("images/facebook-logo.png"),
                Text(
                  "Sign In With FaceBook",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Opacity(
                  opacity: 0,
                  child: Image.asset("images/facebook-logo.png"),
                )
              ],
            ),
            borderRadious: 18,
            fontsize: 15,
            TextColor: Colors.white,
            color: Color(0xFF334D92),
            onpressed: isloading ? null : () => _singInWithFacebook(context),
          ),
          SizedBox(
            height: 10,
          ),
          buildRaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset("images/google-logo.png"),
                Text(
                  "Sign In With Email",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Opacity(
                  opacity: 0,
                  child: Image.asset("images/google-logo.png"),
                )
              ],
            ),
            borderRadious: 18,
            fontsize: 15,
            TextColor: Colors.white,
            color: Colors.teal[700],
            onpressed: isloading ? null : () => SignInwithEmail(context),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "OR",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          buildRaisedButton(
            child: Text("Go Anonymous"),
            borderRadious: 18,
            fontsize: 15,
            TextColor: Colors.black,
            color: Colors.lime[700],
            onpressed: isloading ? null : () => _singInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _SignInIdicator() {
    if (isloading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 34,
      ),
    );
  }
}
