import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/constants.dart';
import 'package:walt/pages/top_page/top_page.dart';

main() async {
  launchWaltApp();
}

launchWaltApp() {
  ProviderScope(
    child: MaterialApp(
      title: appName,
      home: TopPage(),
    ),
  );
}
