import 'package:flutter/widgets.dart';

extension AsyncSnapshotExt on AsyncSnapshot {
  bool get isNothing => connectionState == ConnectionState.none;

  /// Streamに何らかのデータが入っている場合はactive
  bool get isActive => connectionState == ConnectionState.active;

  bool get isDone => connectionState == ConnectionState.done;

  bool get isWaiting => connectionState == ConnectionState.waiting;
}