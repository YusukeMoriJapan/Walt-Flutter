import 'dart:collection';

import 'package:flutter/widgets.dart';

class PageStorageManager {
  static PageStorageManager? _instance;

  final _pageStorageMap = HashMap<String, BuildContext>();

  factory PageStorageManager() {
    if (_instance != null) {
      return _instance as PageStorageManager;
    } else {
      return PageStorageManager._internal();
    }
  }

  PageStorageManager._internal();

  registerPageStorage(String key, BuildContext context) {
    _pageStorageMap[key] = context;
  }

  addData(String key, Object identifier) {}

  removeGeneralData(String key) {}

  removeData(String key, Object identifier) {}

  removeAllData(String key) {
    final context = _pageStorageMap[key];
    if (context == null) return;

    PageStorage.of(context)!.writeState(context, null);
  }
}
