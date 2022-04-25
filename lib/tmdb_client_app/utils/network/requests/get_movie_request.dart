import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../repository/movie_repository.dart';

part 'get_movie_request.freezed.dart';

@freezed
class GetMovieRequestBase with _$GetMovieRequestBase {
  const factory GetMovieRequestBase(
      {required Language language,
      required int page,
      required int? apiVersion,
      // required CancelToken cancelToken,
      required String region}) = _GetMovieRequestBase;
}
