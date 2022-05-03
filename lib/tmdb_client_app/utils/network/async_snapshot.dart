import 'package:flutter/widgets.dart';
import 'package:walt/tmdb_client_app/utils/network/result.dart';
import 'package:walt/tmdb_client_app/utils/throwable/not_provided_exception.dart';

extension AsyncSnapshotExt on AsyncSnapshot {
  bool get isNothing => connectionState == ConnectionState.none;

  /// Streamに何らかのデータが入っている場合はactive
  bool get isActive => connectionState == ConnectionState.active;

  bool get isDone => connectionState == ConnectionState.done;

  bool get isWaiting => connectionState == ConnectionState.waiting;
}

extension AsyncSnapshotExtResult<T extends Result<E>, E> on AsyncSnapshot<T> {
  /// snapshotの結果から型安全にWidgetを生成するための拡張関数
  Widget buildWidget(
      {required Widget Function(E data) onSuccess,
      required Widget Function(FailureReason e) onError}) {
    final result = data;
    final ex = error;

    if (result != null) {
      return result.when(
          success: (value) => onSuccess(value), failure: (e) => onError(e));
    }

    if (ex != null) {
      return onError(ex.toFailureReason());
    } else {
      return onError(FailureReason.exception(
          NotProvidedException("Both a result and an error are null.")));
    }
  }
}
