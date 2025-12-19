import 'package:flutter/material.dart';

class Level0Page extends StatelessWidget {
  const Level0Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level 0 - No Rendering')),
      body: const SizedBox.shrink(),
    );
  }
}
