import 'package:flutter/material.dart';

import 'package:time_tracking_app/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/common/Showdialog.dart';

class Home extends StatelessWidget {
  Future<void> _singInOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
  }

  Future<void> ConfirmsingInOut(BuildContext context) async {
    final confirmation = await Showdialog(
      context,
      Title: "LogOut",
      content: "Are You Sure You want To Logout",
      CancelactionText: "Cancel",
      DefaultActionText: "LogOut",
    );
    if (confirmation == true) {
      await _singInOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          FlatButton(
              child: Text(
                "logOut",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () => ConfirmsingInOut(context)),
        ],
      ),
    );
  }
}
