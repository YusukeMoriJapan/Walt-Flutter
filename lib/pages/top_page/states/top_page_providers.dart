import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/constants.dart';

final topPageTitleProvider = Provider<String>((ref) {
  return appName;
});

var statusBarTopPadding = 0.0;
