import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Level4Page extends StatefulWidget {
  const Level4Page({super.key});

  @override
  State<Level4Page> createState() => _Level4PageState();
}

class _Level4PageState extends State<Level4Page> {
  final StreamController<String> _dataStreamController =
      StreamController<String>();
  StreamSubscription? _subscription;
  int _requestCount = 0;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _subscription = Stream.periodic(
      const Duration(seconds: 2),
    ).asyncMap((_) => _fetchData()).listen((data) {
      if (mounted) {
        _dataStreamController.add(data);
      }
    });
  }

  Future<String> _fetchData() async {
    _requestCount++;
    try {
      // Fetching random data to avoid caching (though we are not caching anyway)
      final response = await http.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/todos/1?_t=${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return 'Request #$_requestCount: ${json['title']}';
      } else {
        return 'Request #$_requestCount: Error ${response.statusCode}';
      }
    } catch (e) {
      return 'Request #$_requestCount: Error $e';
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level 4 - Network Polling')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Polling https://jsonplaceholder.typicode.com/todos/1 every 2s',
            ),
            const SizedBox(height: 20),
            StreamBuilder<String>(
              stream: _dataStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
