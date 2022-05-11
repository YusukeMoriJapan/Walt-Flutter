import 'package:freezed_annotation/freezed_annotation.dart';

import '../result.dart';

part 'paging_result.freezed.dart';

@freezed
abstract class PagingResult<T> with _$PagingResult<T> {
  const factory PagingResult.success(List<T> value) = PagingSuccess<T>;

  const factory PagingResult.failure(FailureReason reason, List<T>? oldList) =
      PagingFailure<T>;
}
