import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retry/retry.dart';

extension FutureEx<T> on Future<T> {
  Future<T> httpDioRetry(
      {required RetryOptions retryOptions, required Duration timeoutDuration}) {
    return retryOptions.retry(() => this.timeout(timeoutDuration),
        retryIf: (e) =>
            e is DioError && e.type != DioErrorType.cancel ||
            e is TimeoutException);
  }
}
