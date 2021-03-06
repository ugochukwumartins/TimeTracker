import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracking_app/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/common/Showdialog.dart';
import 'package:time_tracking_app/common/Showexception.dart';

import 'Validator.dart';
import 'email_sigin_model.dart';
import 'email_sign_in_bloc.dart';

class SignInbodyblocBase extends StatefulWidget {
  final EmailSignInBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => SignInbodyblocBase(
          bloc: bloc,
        ),
      ),
      dispose: (
        _,
        bloc,
      ) =>
          bloc.dispose(),
    );
  }

  SignInbodyblocBase({@required this.bloc});
  @override
  _SignInbodyblocBase createState() => _SignInbodyblocBase();
}

class _SignInbodyblocBase extends State<SignInbodyblocBase> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  FocusNode _emailNode = new FocusNode();
  FocusNode _passwordNode = new FocusNode();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  void emaileditingComplete(EmailSigninModel model) {
    final newfocus =
        model.emailvalidator.Isvalid(model.email) ? _passwordNode : _emailNode;
    FocusScope.of(context).requestFocus(newfocus);
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      await widget.bloc.signIn();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Showexception(
        context,
        title: 'Sing in Failed',
        exception: e,
      );
    }
  }

  void _Toggle() {
    widget.bloc.Toggle();

    _passwordController.clear();
    _emailController.clear();
  }

  List<Widget> buildElement(EmailSigninModel model) {
    return [
      TextField(
        focusNode: _emailNode,
        onChanged: (email) => widget.bloc.updateEmail(email),
        controller: _emailController,
        onEditingComplete: () => emaileditingComplete(model),
        decoration: InputDecoration(
          errorText: model.EmailErroText,
          labelText: "Email",
          hintText: "test@test.com",
          enabled: model.isloading == false,
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
      SizedBox(
        height: 8,
      ),
      TextField(
        focusNode: _passwordNode,
        controller: _passwordController,
        onChanged: (password) => widget.bloc.updatePassword(password),
        decoration: InputDecoration(
          errorText: model.PasswordErroText,
          labelText: "Password",
          enabled: model.isloading == false,
        ),
        textInputAction: TextInputAction.done,
        obscureText: true,
        onEditingComplete: _signIn,
      ),
      SizedBox(
        height: 8,
      ),
      RaisedButton(
        child: Text(model.Primary),
        color: Colors.indigo,
        onPressed: model.cansubmit ? _signIn : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
      SizedBox(
        height: 8,
      ),
      FlatButton(
        child: Text(model.Secondary),
        onPressed: !model.isloading ? () => _Toggle() : null,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSigninModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSigninModel(),
        builder: (context, snapShot) {
          final EmailSigninModel model = snapShot.data;
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: buildElement(model),
            ),
          );
        });
  }
}
