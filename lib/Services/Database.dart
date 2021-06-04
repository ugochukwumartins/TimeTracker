import 'package:flutter/material.dart';
import 'package:time_tracking_app/Models/entry.dart';

import 'package:time_tracking_app/Models/job.dart';

import 'ApiPath.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> setJob(Jobmodel job);
  Future<void> delecomand(Jobmodel job);
  Stream<List<Jobmodel>> readJobsStream();
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Jobmodel job});
  Stream<Jobmodel> JobStream({String JobId});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDataBase implements Database {
  FirestoreDataBase({@required this.Uid}) : assert(Uid != null);
  final String Uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Jobmodel job) => _service.setData(
        path: ApiPath.job(Uid, job.id),
        data: job.toMap(),
      );
  @override
  Future<void> delecomand(Jobmodel job) async {
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
  }

  @override
  Stream<List<Jobmodel>> readJobsStream() => _service.collectionStream(
        path: ApiPath.jobs(Uid),
        builder: (data, document) => Jobmodel.fromMap(data, document),
      );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: ApiPath.entry(Uid, entry.id),
        data: entry.toMap(),
      );
  @override
  Stream<Jobmodel> JobStream({String JobId}) => _service.documentStream(
        path: ApiPath.job(Uid, JobId),
        builder: (data, documentId) => Jobmodel.fromMap(data, documentId),
      );
  @override
  Future<void> deleteEntry(Entry entry) => _service.deledata(
        path: ApiPath.entry(Uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Jobmodel job}) =>
      _service.collectionStream<Entry>(
        path: ApiPath.entries(Uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
