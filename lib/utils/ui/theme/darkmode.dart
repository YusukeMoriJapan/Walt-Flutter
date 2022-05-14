import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) {
  final Brightness brightness = MediaQuery.platformBrightnessOf(context);
  return brightness == Brightness.dark;
}