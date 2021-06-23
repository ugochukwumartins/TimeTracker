import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String PhotoUrl;
  final double radius;
  const Avatar({Key key, this.PhotoUrl, @required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.black54,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: PhotoUrl != null ? NetworkImage(PhotoUrl) : null,
        child: PhotoUrl == null
            ? Icon(
                Icons.camera_alt,
                size: radius,
              )
            : null,
      ),
    );
  }
}
