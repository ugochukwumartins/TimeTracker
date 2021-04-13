import 'package:flutter/material.dart';
import 'package:time_tracking_app/Services/Auth.dart';
import 'Home_Page.dart';
import 'SignIn_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.authchanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User users = snapshot.data;
          if (users == null) {
            return SignInPage.create(context);
          } else {
            return Home();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
