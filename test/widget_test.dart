// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracking_app/Models/job.dart';

import 'package:time_tracking_app/main.dart';

void main() {
  group('job-test', () {
    test('tester o', () {
      final jobs = Jobmodel.fromMap(null, "fb");
      expect(jobs, null);
    });
    test('tester t', () {
      final jobs = Jobmodel.fromMap({
        'name': 'Ugomartins',
        'ratePerHour': 8,
      }, 'fbs');
      expect(jobs, Jobmodel(name: 'Ugomartins', ratePerhour: 8, id: 'fbs'));
    });
  });
}
