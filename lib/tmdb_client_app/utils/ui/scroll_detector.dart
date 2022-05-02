import 'package:flutter/material.dart';

class ScrollDetector extends StatefulWidget {
  final Widget Function(BuildContext, ScrollController) builder;
  final VoidCallback onThresholdExceeded;
  final double threshold;

  const ScrollDetector({
    required this.builder,
    required this.onThresholdExceeded,
    required this.threshold,
  });

  @override
  _ScrollDetectorState createState() => _ScrollDetectorState();
}

class _ScrollDetectorState extends State<ScrollDetector> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        final scrollValue =
            _controller.offset / _controller.position.maxScrollExtent;
        if (scrollValue > widget.threshold) {
          widget.onThresholdExceeded();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}