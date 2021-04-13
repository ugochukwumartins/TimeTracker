import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracking_app/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/common/Showdialog.dart';
import 'package:time_tracking_app/common/Showexception.dart';

import 'Validator.dart';

enum EmailSignInFormType { signIn, Register }

class SignInbody extends StatefulWidget with emailandPasswordValidator {
  @override
  _SignInbodyState createState() => _SignInbodyState();
}

class _SignInbodyState extends State<SignInbody> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool submitted = false;
  FocusNode _emailNode = new FocusNode();
  FocusNode _passwordNode = new FocusNode();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _isLoading = false;

  void emaileditingComplete() {
    final newfocus =
        widget.emailvalidator.Isvalid(_email) ? _passwordNode : _emailNode;
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

  void _signIn() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await auth.singinWithEmail(_email, _password);
      } else {
        await auth.singinCreateAccountWithEmail(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Showexception(
        context,
        title: 'Sing in Failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _update() {
    setState(() {});
  }

  void _Toggle() {
    setState(() {
      submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.Register
          : EmailSignInFormType.signIn;
    });
    _passwordController.clear();
    _emailController.clear();
  }

  List<Widget> buildElement() {
    bool emailvalid = submitted && !widget.emailvalidator.Isvalid(_email);
    bool passswordvalid =
        submitted && !widget.passwordvalidator.Isvalid(_password);
    bool sumitCheck = widget.emailvalidator.Isvalid(_email) &&
        widget.passwordvalidator.Isvalid(_password) &&
        !_isLoading;
    final primary = _formType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create an Account";
    final secondary = _formType == EmailSignInFormType.signIn
        ? "Need an Account ? Register"
        : "Have an Account ? Sign in";
    return [
      TextField(
        focusNode: _emailNode,
        onChanged: (emal) => _update(),
        controller: _emailController,
        onEditingComplete: emaileditingComplete,
        decoration: InputDecoration(
          errorText: emailvalid ? widget.emailError : null,
          labelText: "Email",
          hintText: "test@test.com",
          enabled: _isLoading == false,
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
        onChanged: (password) => _update(),
        decoration: InputDecoration(
          errorText: passswordvalid ? widget.passwordError : null,
          labelText: "Password",
          enabled: _isLoading == false,
        ),
        textInputAction: TextInputAction.done,
        obscureText: true,
        onEditingComplete: _signIn,
      ),
      SizedBox(
        height: 8,
      ),
      RaisedButton(
        child: Text(primary),
        color: Colors.indigo,
        onPressed: sumitCheck ? _signIn : null,
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
        child: Text(secondary),
        onPressed: !_isLoading ? _Toggle : null,
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
