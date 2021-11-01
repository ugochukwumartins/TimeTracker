import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracking_app/SignUpButtons/raiseButton.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
    var press = false;
    await tester.pumpWidget(MaterialApp(
        home: buildRaisedButton(
      onpressed: () => press = true,
    )));
    final button = find.byType(RaisedButton);
    expect(button, findsOneWidget);
    await tester.tap(button);
    expect(press, true);
  });
}
