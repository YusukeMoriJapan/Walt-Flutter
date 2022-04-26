import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useFullScreenUntilDispose([List<Object?>? keys]) {
  useEffect(() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    };
  }, keys);
}
