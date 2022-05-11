import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repository/credits_repository.dart';
import '../repository/movie_repository.dart';

final getMovieCreditsUseCase = Provider((ref) {
  return ({
    required int apiVersion,
    required int movieId,
    required Language language,
    required CancelToken cancelToken,
  }) {
    return ref.read(creditsRepository).getMovieCredits(
          movieId: movieId,
          apiVersion: apiVersion,
          language: language,
          cancelToken: cancelToken,
        );
  };
});
