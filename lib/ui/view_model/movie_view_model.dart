import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/entity/movie/movie.dart';
import '../../models/entity/movie/movie_detail/movie_details.dart';
import '../../models/entity/movie/movie_list.dart';
import '../../models/region/region.dart';
import '../../repository/movie_repository.dart';
import '../../use_cases/get_movie_details_use_case.dart';
import '../../use_cases/get_movies_use_case.dart';
import '../../utils/network/paging/paging_result.dart';
import '../../utils/network/result.dart';
import '../../utils/throwable/cannot_find_value_from_key_exception.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final movieViewModelProvider = Provider.autoDispose
    .family<MovieViewModel, MovieViewModelParam>(
        (ref, param) => MovieViewModel(ref.read, param.language, param.region));

class MovieViewModel {
  final Reader _read;
  final Language lang;
  final Region region;

  late final MovieList trendingMovieList;
  late final MovieList upComingMovieList;
  late final MovieList popularMovieList;

  late final MovieList topRatedMovieList;
  final Map<String, MovieList> _customMoviesMap = {};

  MovieViewModel(this._read, this.lang, this.region) {
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
        language: lang,
        page: trendingMovieList.currentPage,
        apiVersion: 3,
        timeWindow: TimeWindow.day,
        oldMovieList: trendingMovieList.currentMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestPopularMovies() async {
    return await _read(getPopularMoviesUseCase).call(
        language: lang,
        page: popularMovieList.currentPage,
        apiVersion: 3,
        region: region,
        timeWindow: TimeWindow.day,
        oldMovieList: popularMovieList.currentMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestTopRatedMovies() async {
    return await _read(getTopRatedMoviesUseCase).call(
        language: lang,
        page: topRatedMovieList.currentPage,
        apiVersion: 3,
        region: region,
        oldMovieList: topRatedMovieList.currentMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestUpComingMovies() async {
    return await _read(getUpComingMoviesUseCase).call(
        language: lang,
        page: upComingMovieList.currentPage,
        apiVersion: 3,
        region: region,
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
          language: lang,
          page: customList.currentPage,
          includeAdult: false,
          sortBy: sortBy,
          apiVersion: 3,
          region: region,
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
        language: lang,
        movieId: movieId,
        cancelToken: CancelToken(),
        appendToResponse: null,
        apiVersion: 3);
  }
}

class MovieViewModelParam {
  final Language language;
  final Region region;

  const MovieViewModelParam({
    required this.language,
    required this.region,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovieViewModelParam &&
          runtimeType == other.runtimeType &&
          language == other.language &&
          region == other.region);

  @override
  int get hashCode => language.hashCode ^ region.hashCode;

  @override
  String toString() {
    return 'MovieViewModelParam{' +
        ' language: $language,' +
        ' region: $region,' +
        '}';
  }

  MovieViewModelParam copyWith({
    Language? language,
    Region? region,
  }) {
    return MovieViewModelParam(
      language: language ?? this.language,
      region: region ?? this.region,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'region': region,
    };
  }

  factory MovieViewModelParam.fromMap(Map<String, dynamic> map) {
    return MovieViewModelParam(
      language: map['language'] as Language,
      region: map['region'] as Region,
    );
  }
}
