import 'package:async/async.dart' as async;
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/entity/combined_entity/movie_details_with_credits.dart';
import 'package:walt/models/entity/movie/movie_detail/movie_details.dart';
import 'package:walt/models/entity/people/credits.dart';
import 'package:walt/repository/credits_repository.dart';
import 'package:walt/utils/network/result.dart';

import '../models/request/append_to_response.dart';
import '../repository/movie_repository.dart';

final getMovieDetailsWithCreditsUseCase = Provider((ref) {
  return (
      {required Language language,
      required int apiVersion,
      required int movieId,
      required CancelToken cancelToken,
      required AppendToResponse? appendToResponse}) async {
    final combinedTask = async.FutureGroup()
      ..add(ref.watch(movieRepository).getMovieDetails(
          language: language,
          apiVersion: apiVersion,
          cancelToken: cancelToken,
          appendToResponse: appendToResponse,
          movieId: movieId))
      ..add(ref.watch(creditsRepository).getMovieCredits(
            movieId: movieId,
            apiVersion: apiVersion,
            language: language,
            cancelToken: cancelToken,
          ))
      ..close();

    final awaitedFutureTask = await combinedTask.future;

    final movieDetailsResult =
        awaitedFutureTask.whereType<Result<MovieDetails>>().first;
    final movieCreditsResult =
        awaitedFutureTask.whereType<Result<Credits>>().first;

    return movieDetailsResult.when<Result<MovieDetailsWithCredits>>(
        success: (movieDetails) => movieCreditsResult.when(
            success: (credits) => Result.success(MovieDetailsWithCredits(
                movieDetails: movieDetails, credits: credits)),
            failure: (e) => Result.success(MovieDetailsWithCredits(
                movieDetails: movieDetails, credits: null))),
        failure: (e) => Result.failure(e));
  };
});
