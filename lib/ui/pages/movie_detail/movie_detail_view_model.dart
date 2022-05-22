import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/movie_constant.dart';
import 'package:walt/models/entity/combined_entity/movie_details_with_credits.dart';
import 'package:walt/ui/states/movies_state.dart';
import 'package:walt/ui/view_model/movies_state_view_model.dart';
import 'package:walt/use_cases/get_movie_details_with_credits_use_case.dart';

import '../../../models/entity/people/credits.dart';
import '../../../repository/movie_repository.dart';
import '../../../use_cases/get_movie_credits_use_case.dart';
import '../../../utils/network/result.dart';

final movieDetailViewModelProvider = Provider.autoDispose
    .family<MovieDetailViewModel, Language>(
        (ref, param) => MovieDetailViewModel(ref.watch, param));

class MovieDetailViewModel with MoviesStateViewModelMixIn {
  final Reader _read;
  final Language lang;

  MovieDetailViewModel(this._read, this.lang) {
    trendingMovies =
        _read(movieStateProvider(const MoviesStateParam(trendingMovieListKey)));
    upComingMovies =
        _read(movieStateProvider(const MoviesStateParam(upComingMovieListKey)));
    popularMovies =
        _read(movieStateProvider(const MoviesStateParam(popularMovieListKey)));
    topRatedMovies =
        _read(movieStateProvider(const MoviesStateParam(topRatedMovieListKey)));

    customMoviesMap = _read(customMovieStateMapProvider);
  }

  Future<Result<Credits>> getMovieCredits(int movieId) =>
      _read(getMovieCreditsUseCase)(
          language: lang,
          movieId: movieId,
          cancelToken: CancelToken(),
          apiVersion: 3);
  Future<Result<MovieDetailsWithCredits>> getMovieDetailsWithCredits(
          int movieId) =>
      _read(getMovieDetailsWithCreditsUseCase)(
          language: lang,
          apiVersion: 3,
          movieId: movieId,
          cancelToken: CancelToken(),
          appendToResponse: null);
}
