import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:walt/tmdb_client_app/models/entity/movie/movie_detail/movie_details.dart';
import 'package:walt/tmdb_client_app/models/region/region.dart';
import 'package:walt/tmdb_client_app/use_cases/get_movie_details_use_case.dart';
import 'package:walt/tmdb_client_app/utils/throwable/cannot_find_value_from_key_exception.dart';

import '../../models/entity/movie/movie.dart';
import '../../models/entity/movie/movie_list.dart';
import '../../repository/movie_repository.dart';
import '../../use_cases/get_movies_use_case.dart';
import '../../utils/network/paging/paging_result.dart';
import '../../utils/network/paging/paging_result.dart';
import '../../utils/network/result.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final movieViewModelProvider =
    Provider.autoDispose((ref) => MovieViewModel(ref.read));

class MovieViewModel {
  final Reader _read;

  late final MovieList trendingMovieList;
  late final MovieList upComingMovieList;
  late final MovieList popularMovieList;

  late final MovieList topRatedMovieList;
  final Map<String, MovieList> _customMoviesMap = {};

  MovieViewModel(this._read) {
    trendingMovieList = MovieList(() => _requestTrendingMovies());
    upComingMovieList = MovieList(() => _requestUpComingMovies());
    popularMovieList = MovieList(() => _requestPopularMovies());
    topRatedMovieList = MovieList(() => _requestTopRatedMovies());

    trendingMovieList.refreshMovieList();
    upComingMovieList.refreshMovieList();
    popularMovieList.refreshMovieList();
    topRatedMovieList.refreshMovieList();
  }

  Future<PagingResult<Movie>> _requestTrendingMovies() async {
    return await _read(getTrendingMoviesUseCase).call(
        language: Language.japanese,
        page: trendingMovieList.currentPage,
        apiVersion: 3,
        timeWindow: TimeWindow.day,
        oldMovieList: trendingMovieList.currentMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestPopularMovies() async {
    return await _read(getPopularMoviesUseCase).call(
        language: Language.japanese,
        page: popularMovieList.currentPage,
        apiVersion: 3,
        region: Region.japan,
        timeWindow: TimeWindow.day,
        oldMovieList: popularMovieList.currentMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestTopRatedMovies() async {
    return await _read(getTopRatedMoviesUseCase).call(
        language: Language.japanese,
        page: topRatedMovieList.currentPage,
        apiVersion: 3,
        region: Region.japan,
        oldMovieList: topRatedMovieList.currentMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestUpComingMovies() async {
    return await _read(getUpComingMoviesUseCase).call(
        language: Language.japanese,
        page: upComingMovieList.currentPage,
        apiVersion: 3,
        region: Region.japan,
        timeWindow: TimeWindow.day,
        oldMovieList: upComingMovieList.currentMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestCustomDiscoveredMovies({
    required String listKey,
    required String sortBy,
    double? voteAverageGte,
    double? voteAverageLte,
    int? year,
    String? withGenres,
    String? withKeywords,
    String? withOriginalLanguage,
    String? withWatchMonetizationTypes,
    String? watchRegion,
  }) async {
    final customList = _customMoviesMap[listKey];

    if (customList == null) {
      return PagingResult.failure(
          FailureReason.exception(CannotFindValueFromKeyException(
              "Searched any matched list based on the key,but couldn't find it.")),
          null);
    } else {
      return await _read(getDiscoveredMoviesUseCase).call(
          language: Language.japanese,
          page: customList.currentPage,
          includeAdult: false,
          sortBy: sortBy,
          apiVersion: 3,
          region: Region.japan,
          oldMovieList: customList.currentMovieList,
          cancelToken: CancelToken(),
          voteAverageGte: voteAverageGte,
          voteAverageLte: voteAverageLte,
          year: year,
          withGenres: withGenres,
          withKeywords: withKeywords,
          withOriginalLanguage: withOriginalLanguage,
          withWatchMonetizationTypes: withWatchMonetizationTypes,
          watchRegion: watchRegion);
    }
  }

  bool registerCustomDiscoveredMovieList(
    String key,
    String? withGenres,
    String sortBy,
  ) {
    final matchedList = _customMoviesMap[key];

    if (matchedList == null) {
      _customMoviesMap[key] = MovieList(() => _requestCustomDiscoveredMovies(
          listKey: key, sortBy: sortBy, withGenres: withGenres));
      return true;
    } else {
      return false;
    }
  }

  MovieList? getCustomMovieList(String key) {
    return _customMoviesMap[key];
  }

  Future<Result<MovieDetails>> getMovieDetails(int movieId) async {
    return await _read(getMovieDetailsUseCase)(
        language: Language.japanese,
        movieId: movieId,
        cancelToken: CancelToken(),
        appendToResponse: null,
        apiVersion: 3);
  }
}
