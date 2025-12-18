import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exploring_devtools/main.dart';

void main() {
  testWidgets('Bottom navigation bar smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we start at Level 1.
    expect(find.text('You are on Level 1'), findsOneWidget);

    // Verify that the BottomNavigationBar is present.
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Tap on "Level 2" icon.
    await tester.tap(find.text('Level 2'));
    await tester.pump();

    // Verify that we are on Level 2 page.
    expect(find.text('You are on Level 2'), findsOneWidget);
    expect(find.text('You are on Level 1'), findsNothing);

    // Tap on "Level 5" icon.
    await tester.tap(find.text('Level 5'));
    await tester.pump();

    // Verify that we are on Level 5 page.
    expect(find.text('You are on Level 5'), findsOneWidget);
  });
}
