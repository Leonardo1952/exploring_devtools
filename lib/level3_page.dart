import 'package:flutter/material.dart';

import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;

class Level3Page extends StatefulWidget {
  const Level3Page({super.key});

  @override
  State<Level3Page> createState() => _Level3PageState();
}

class _Level3PageState extends State<Level3Page> {
  double _offset = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Animate to force constant repainting
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          _offset += 0.02;
          if (_offset > 2 * 3.14159) _offset -= 2 * 3.14159;
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
      appBar: AppBar(title: const Text('Level 3 - GPU Stress')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(math.sin(_offset), math.cos(_offset)),
                end: Alignment(-math.sin(_offset), -math.cos(_offset)),
                colors: [
                  HSVColor.fromAHSV(
                    1.0,
                    (_offset * 50) % 360,
                    1.0,
                    1.0,
                  ).toColor(),
                  HSVColor.fromAHSV(
                    1.0,
                    ((_offset * 50) + 180) % 360,
                    1.0,
                    1.0,
                  ).toColor(),
                ],
              ),
            ),
          ),
          // Many overlapping shadows and blurs
          ...List.generate(20, (index) {
            return Positioned(
              top: 50.0 * index + 20 * math.sin(1 + _offset),
              left: 20.0 * index + 20 * math.cos(1 + _offset),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: Text(
                      'Blur $index',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
