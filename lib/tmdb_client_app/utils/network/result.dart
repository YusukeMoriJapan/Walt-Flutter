import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;

  const factory Result.failure(FailureReason reason) = Failure<T>;
}

@freezed
abstract class FailureReason with _$FailureReason {
  const factory FailureReason.exception(Exception value) = ExceptionReason;

  const factory FailureReason.error(Error error) = ErrorReason;
}

extension FailureReasonEx on Object {
  FailureReason toFailureReason() {
    if (this is Exception) {
      return FailureReason.exception(this as Exception);
    } else {
      return FailureReason.error(this as Error);
    }
  }
}
