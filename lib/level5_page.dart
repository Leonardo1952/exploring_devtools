import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

class Level5Page extends StatefulWidget {
  const Level5Page({super.key});

  @override
  State<Level5Page> createState() => _Level5PageState();
}

class _Level5PageState extends State<Level5Page> {
  Timer? _timer;
  StreamSubscription? _sensorSubscription;
  StreamSubscription? _networkSubscription;
  double _x = 0, _y = 0, _z = 0;
  int _counter = 0;
  String _networkData = 'Loading...';

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        _blockMainThread();
        setState(() {
          _counter++;
          _x = sin(_counter * 0.1) * 9.8;
          _y = cos(_counter * 0.1) * 9.8;
          _z = sin(_counter * 0.05) * 5.0;
        });
      }
    });

    _sensorSubscription = accelerometerEventStream().listen(
      (event) {
        if (mounted) {
          setState(() {
            _x = event.x;
            _y = event.y;
            _z = event.z;
          });
        }
      },
      onError: (e) {
        debugPrint('Sensor error: $e');
      },
    );

    _networkSubscription = Stream.periodic(
      const Duration(seconds: 2),
    ).asyncMap((_) => _fetchData()).listen((data) {
      if (mounted) {
        setState(() {
          _networkData = data;
        });
      }
    });
  }

  void _blockMainThread() {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsedMilliseconds < 20) {
      double res = 0;
      for (int i = 0; i < 1000; i++) {
        res += sqrt(i);
      }
      if (res < 0) debugPrint('Should not happen');
    }
  }

  Future<String> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/todos/1?_t=${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      return 'Net: ${response.statusCode}';
    } catch (e) {
      return 'Net: Err';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sensorSubscription?.cancel();
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level 5 - The Worst Scenario')),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 1000,
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                color: Color.fromARGB(
                  255,
                  (index * 10 + _counter) % 255,
                  (index * 20 + _counter) % 255,
                  (index * 30 + _counter) % 255,
                ),
                child: Center(child: Text('Item $index - $_counter')),
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Image.network(
              'https://picsum.photos/1000/1000?random=$_counter',
              key: ValueKey(_counter ~/ 100),
              width: 150,
              height: 150,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FPS Killer Mode',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'X: ${_x.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Y: ${_y.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Z: ${_z.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    _networkData,
                    style: const TextStyle(color: Colors.yellow),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
