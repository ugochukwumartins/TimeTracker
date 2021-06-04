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
      body: _buildActionContext(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddAndEdithJob.show(
          context,
          database: Provider.of<Database>(context, listen: false),
        ),
      ),
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
