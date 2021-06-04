import 'package:flutter/material.dart';
import 'package:time_tracking_app/Models/job.dart';

class JobStyle extends StatelessWidget {
  const JobStyle({Key key, @required this.job, this.onTap}) : super(key: key);
  final Jobmodel job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
