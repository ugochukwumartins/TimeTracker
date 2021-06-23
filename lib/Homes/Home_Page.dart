import 'package:flutter/material.dart';
import 'package:time_tracking_app/Homes/Empty.dart';
import 'package:time_tracking_app/Homes/job_entries/job_entries_page.dart';
import 'package:time_tracking_app/ListViewReusable/ListviewBuilder.dart';
import 'package:time_tracking_app/Models/job.dart';

import 'package:time_tracking_app/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/Services/Database.dart';
import 'package:time_tracking_app/common/Showdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracking_app/common/Showexception.dart';

import 'AddJobPage.dart';
import 'job_list_style.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Jobmodel job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.delecomand(job);
    } on FirebaseException catch (e) {
      Showexception(
        context,
        title: "operation Failed",
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        actions: <Widget>[
          IconButton(
            onPressed: () => AddAndEdithJob.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildActionContext(context),
    );
  }

  Widget _buildActionContext(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Jobmodel>>(
      stream: database.readJobsStream(),
      builder: (context, snapShot) {
        return ListItemBuilder<Jobmodel>(
          snapshot: snapShot,
          itembuider: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobStyle(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }
}
