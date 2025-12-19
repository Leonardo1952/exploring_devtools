import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:exploring_devtools/main.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() {
  testWidgets('Bottom navigation bar smoke test', (WidgetTester tester) async {
    await HttpOverrides.runZoned(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that we start at Level 1 and see the list.
      expect(find.text('Item 0'), findsOneWidget);

      // Verify that the BottomNavigationBar is present.
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Tap on "Level 2" icon.
      await tester.tap(find.text('Level 2'));
      // Use pump because Level 2 has an infinite timer.
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that we are on Level 2 page.
      expect(
        find.widgetWithText(AppBar, 'Level 2 - Excessive Rebuilds'),
        findsOneWidget,
      );
      expect(find.text('This list rebuilds every 16ms!'), findsWidgets);
      expect(find.text('Item 0'), findsNothing);

      // Tap on "Level 3" icon.
      await tester.tap(find.byIcon(Icons.looks_3));
      // Use pump because Level 3 also has an infinite timer.
      await tester.pump(); // Start navigation
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // Wait for transition

      // Verify that we are on Level 3 page.
      expect(
        find.widgetWithText(AppBar, 'Level 3 - GPU Stress'),
        findsOneWidget,
      );
      expect(find.text('Blur 0'), findsOneWidget);

      // Tap on "Level 4" icon.
      await tester.tap(find.text('Level 4'));
      await tester.pump(); // Start navigation
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // Wait for transition

      // Verify that we are on Level 4 page.
      expect(
        find.widgetWithText(AppBar, 'Level 4 - Network Polling'),
        findsOneWidget,
      );
      // Wait for polling (2 seconds)
      await tester.pump(const Duration(seconds: 3));
      // Should see "Request #1: Mock Title"
      expect(find.textContaining('Request #'), findsOneWidget);

      // Tap on "Level 5" icon.
      await tester.tap(find.byIcon(Icons.looks_5));
      await tester.pump();
      // Level 5 has heavy rebuilds and blocking tasks.
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that we are on Level 5 page.
      expect(
        find.widgetWithText(AppBar, 'Level 5 - The Worst Scenario'),
        findsOneWidget,
      );
      expect(find.text('FPS Killer Mode'), findsOneWidget);
    }, createHttpClient: (_) => _createMockImageHttpClient());
  });
}

// Returns a mock HTTP client that responds with a blank image to all requests.
HttpClient _createMockImageHttpClient() {
  final client = MockHttpClient();
  return client;
}

class MockHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest(url);
  }
}

class MockHttpClientRequest extends Fake implements HttpClientRequest {
  final Uri url;
  MockHttpClientRequest(this.url);

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse(url);
  }
}

class MockHttpClientResponse extends Fake implements HttpClientResponse {
  final Uri url;
  MockHttpClientResponse(this.url);

  @override
  int get statusCode => 200;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    List<int> responseData;
    if (url.toString().contains('jsonplaceholder')) {
      responseData = utf8.encode('{"title": "Mock Title"}');
    } else {
      // Minimal transparent 1x1 GIF
      responseData = <int>[
        0x47,
        0x49,
        0x46,
        0x38,
        0x39,
        0x61,
        0x01,
        0x00,
        0x01,
        0x00,
        0x80,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x21,
        0xf9,
        0x04,
        0x01,
        0x00,
        0x00,
        0x00,
        0x00,
        0x2c,
        0x00,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x01,
        0x00,
        0x00,
        0x02,
        0x02,
        0x44,
        0x01,
        0x00,
        0x3b,
      ];
    }

    return Stream<List<int>>.fromIterable(<List<int>>[responseData]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
