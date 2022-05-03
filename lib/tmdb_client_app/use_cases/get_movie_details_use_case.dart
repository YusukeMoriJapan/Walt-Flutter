import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/models/request/append_to_response.dart';

import '../repository/movie_repository.dart';

final getMovieDetailsUseCase = Provider((ref) {
  return (
      {required Language language,
      required int apiVersion,
      required int movieId,
      required CancelToken cancelToken,
      required AppendToResponse? appendToResponse}) {
    return ref.read(movieRepository).getMovieDetails(
        language: language,
        apiVersion: apiVersion,
        cancelToken: cancelToken,
        appendToResponse: appendToResponse,
        movieId: movieId);
  };
});
