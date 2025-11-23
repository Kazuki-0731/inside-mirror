// Basic smoke test for the camera mirror app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inside_mirror/main.dart';

void main() {
  testWidgets('App starts and shows MirrorScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is correct
    expect(find.text('カメラミラー'), findsOneWidget);
  });
}
