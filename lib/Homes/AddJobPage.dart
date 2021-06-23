import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_tracking_app/Models/job.dart';
import 'package:time_tracking_app/Services/Database.dart';
import 'package:time_tracking_app/common/Showdialog.dart';
import 'package:time_tracking_app/common/Showexception.dart';

class AddAndEdithJob extends StatefulWidget {
  const AddAndEdithJob({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Jobmodel job;

  static Future<void> show(BuildContext context,
      {Database database, Jobmodel job}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => AddAndEdithJob(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddAndEdithJobState createState() => _AddAndEdithJobState();
}

class _AddAndEdithJobState extends State<AddAndEdithJob> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _Rateperhour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _Rateperhour = widget.job.ratePerhour;
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    try {
      if (_validateAndSave()) {
        final jobs = await widget.database.readJobsStream().first;
        final allnames = jobs.map((jobs) => jobs.name).toList();
        if (widget.job != null) {
          allnames.remove(widget.job.name);
        }
        if (allnames.contains(_name)) {
          Showdialog(context,
              Title: "Name already in use",
              content: "Chose another name",
              DefaultActionText: "Ok");
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Jobmodel(name: _name, ratePerhour: _Rateperhour, id: id);
          print("$_name  : $_Rateperhour");
          await widget.database.setJob(job);

          Navigator.of(context).pop();
        }
      }
    } on FirebaseException catch (e) {
      Showexception(
        context,
        title: ' Failed to Save',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? "New Job" : "Edit Job"),
        elevation: 2.0,
        actions: <Widget>[
          FlatButton(
              onPressed: _submit,
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white54,
                ),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _SignInIdicator(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _formChilren(),
            )
          ]),
    );
  }

  List<Widget> _formChilren() {
    return <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: "Job Name"),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : "Cant be Empty",
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Rate per hour"),
        initialValue: _Rateperhour != null ? "$_Rateperhour" : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _Rateperhour = int.tryParse(value) ?? 0,
        validator: (value) => value.isNotEmpty ? null : "Cant be Empty",
      )
    ];
  }

  Widget _SignInIdicator() {
    if (isloading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      widget.job == null ? "Create Task" : "Edit Task",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }
}
