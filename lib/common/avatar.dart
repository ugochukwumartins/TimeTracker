import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String PhotoUrl;
  final double radius;
  const Avatar({Key key, this.PhotoUrl, @required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.black12,
      backgroundImage: PhotoUrl != null ? NetworkImage(PhotoUrl) : null,
      child: PhotoUrl == null
          ? Icon(
              Icons.camera_alt,
              size: radius,
            )
          : null,
    );
  }
}
