import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ScrollDetector extends StatefulWidget {
  final Widget Function(BuildContext, AutoScrollController) builder;
  final VoidCallback onThresholdExceeded;
  final double threshold;
  final AutoScrollController controller;
  late final void Function() controllerListener;

  ScrollDetector(
      {Key? key,
      required this.builder,
      required this.onThresholdExceeded,
      required this.threshold,
      required this.controller})
      : super(key: key) {
    controllerListener = () {
      final scrollValue =
          controller.offset / controller.position.maxScrollExtent;
      if (scrollValue > threshold) {
        onThresholdExceeded();
      }
    };
  }

  @override
  _ScrollDetectorState createState() => _ScrollDetectorState();
}

class _ScrollDetectorState extends State<ScrollDetector> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(widget.controllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.controller);
  }

  @override
  void dispose() {
    widget.controller.removeListener(widget.controllerListener);
    super.dispose();
  }
}
