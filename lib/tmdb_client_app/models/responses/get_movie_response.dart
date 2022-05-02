import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walt/tmdb_client_app/utils/network/result.dart';

import '../entity/movie/movie.dart';

part 'get_movie_response.freezed.dart';

part 'get_movie_response.g.dart';

@freezed
class GetMoviesResponse with _$GetMoviesResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetMoviesResponse({
    required num? page,
    required List<Movie>? results,
    required num? totalPages,
    required num? totalResults,
  }) = _GetMovieResult;

  factory GetMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMoviesResponseFromJson(json);
}

extension GetMoviesResponseEx on GetMoviesResponse {
  Result<List<Movie>> toMoviesResult() {
    try {
      final movies = results;

      if (movies == null) {
        ///TODO:FIX 自作エラーでラップする方が良い
        throw const HttpException(
            "Fetching process has been completed normally. but popular movies is null.");
      }
      return Result.success(movies);
    } catch (e) {
      return Result.failure(e.toFailureReason());
    }
  }
}
