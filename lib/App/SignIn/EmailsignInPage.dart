import 'package:flutter/material.dart';
import 'package:time_tracking_app/Services/Auth.dart';

import 'SigninPageEmail.dart';
import 'emailSignInForm_blocBase.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Card(
          child: SignInbodyblocBase.create(context),
        ),
      ),
    );
  }
}
