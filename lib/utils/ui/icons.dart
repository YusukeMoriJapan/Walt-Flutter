import 'dart:ui';

import 'package:flutter/material.dart';

class ShadowIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color shadowColor;

  const ShadowIcon(this.icon,
      {Key? key,
      required this.color,
      required this.backgroundColor,
      required this.shadowColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 5,
                ),
              ]),
          child: Icon(
            Icons.clear,
            color: color,
            size: 25,
          )),
    );
  }
}
