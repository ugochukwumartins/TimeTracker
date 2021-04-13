import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> Showdialog(
  BuildContext context, {
  @required String Title,
  @required String content,
  String CancelactionText,
  @required String DefaultActionText,
}) {
  if (!Platform.isIOS) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(Title),
              content: Text(content),
              actions: [
                if (CancelactionText != null)
                  FlatButton(
                    child: Text(CancelactionText),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(DefaultActionText),
                )
              ],
            ));
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(Title),
              content: Text(content),
              actions: [
                if (CancelactionText != null)
                  CupertinoDialogAction(
                    child: Text(CancelactionText),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(DefaultActionText),
                )
              ],
            ));
  }
}
