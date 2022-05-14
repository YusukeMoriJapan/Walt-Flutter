import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../ui/theme/darkmode.dart';

void useFullScreenUntilDispose([List<Object?>? keys]) {
  useEffect(() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    };
  }, keys);
}

bool useDarkModeState() {
  return useMemoized(
      () => isDarkMode(useContext()), [Theme.of(useContext()).brightness]);
}
