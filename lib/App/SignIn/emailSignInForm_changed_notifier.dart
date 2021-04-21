import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracking_app/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/common/Showdialog.dart';
import 'package:time_tracking_app/common/Showexception.dart';

import 'Validator.dart';
import 'email_sigin_changed_model.dart';
import 'email_sigin_model.dart';
import 'email_sign_in_bloc.dart';

class SignInbodyChangedNotifier extends StatefulWidget {
  final EmailSigninChangedModel model;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSigninChangedModel>(
      create: (_) => EmailSigninChangedModel(auth: auth),
      child: Consumer<EmailSigninChangedModel>(
        builder: (_, model, __) => SignInbodyChangedNotifier(
          model: model,
        ),
      ),
    );
  }

  SignInbodyChangedNotifier({@required this.model});
  @override
  _SignInbodyChangedNotifier createState() => _SignInbodyChangedNotifier();
}

class _SignInbodyChangedNotifier extends State<SignInbodyChangedNotifier> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  EmailSigninChangedModel get model => widget.model;
  FocusNode _emailNode = new FocusNode();
  FocusNode _passwordNode = new FocusNode();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  void emaileditingComplete() {
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
      await widget.model.signIn();
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
    widget.model.Toggle();

    _passwordController.clear();
    _emailController.clear();
  }

  List<Widget> buildElement() {
    return [
      TextField(
        focusNode: _emailNode,
        onChanged: (email) => model.updateEmail(email),
        controller: _emailController,
        onEditingComplete: () => emaileditingComplete(),
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
        onChanged: (password) => model.updatePassword(password),
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
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: buildElement(),
      ),
    );
  }
}
