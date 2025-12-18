import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';

class Level2Page extends StatefulWidget {
  const Level2Page({super.key});

  @override
  State<Level2Page> createState() => _Level2PageState();
}

class _Level2PageState extends State<Level2Page> {
  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          _counter++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level 2 - Excessive Rebuilds')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index) {
          final randomColor =
              Colors.primaries[Random().nextInt(Colors.primaries.length)];
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: randomColor,
              child: Center(child: Text('${_counter % 100}')),
            ),
            title: Text('Item $index - Rebuilds: $_counter'),
            subtitle: const Text('This list rebuilds every 16ms!'),
          );
        },
      ),
    );
  }
}
