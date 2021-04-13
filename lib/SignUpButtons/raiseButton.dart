import 'package:flutter/material.dart';

class buildRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color TextColor;
  final double borderRadious;
  final double fontsize;
  final VoidCallback onpressed;

  const buildRaisedButton(
      {Key key,
      this.color,
      this.borderRadious,
      this.onpressed,
      this.child,
      this.fontsize,
      this.TextColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: RaisedButton(
        onPressed: onpressed,
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadious),
          ),
        ),
      ),
    );
  }
}
