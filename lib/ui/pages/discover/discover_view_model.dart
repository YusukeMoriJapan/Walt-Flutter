import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../models/entity/movie/movie_detail/movie_details.dart';
import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';
import '../../../use_cases/get_movie_details_use_case.dart';
import '../../../use_cases/get_movies_use_case.dart';
import '../../../utils/network/paging/paging_result.dart';
import '../../../utils/network/result.dart';
import '../../../utils/throwable/cannot_find_value_from_key_exception.dart';
import '../../states/movie_list.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final discoverViewModelProvider = Provider.autoDispose
    .family<DiscoverViewModel, DiscoverViewModelParam>((ref, param) =>
        DiscoverViewModel(ref.watch, param.language, param.region));

class DiscoverViewModel {
  final Reader _read;
  final Language lang;
  final Region region;

  late final MoviesState trendingMovieList;
  late final MoviesState upComingMovieList;
  late final MoviesState popularMovieList;
  late final MoviesState topRatedMovieList;

  late final Map<String, MoviesState> _customMovieStateMap;

  DiscoverViewModel(this._read, this.lang, this.region) {
    trendingMovieList = _read(movieStateProvider(
        MoviesStateParam(trendingMovieListKey, _requestTrendingMovies)));
    upComingMovieList = _read(movieStateProvider(
        MoviesStateParam(upComingMovieListKey, _requestUpComingMovies)));
    popularMovieList = _read(movieStateProvider(
        MoviesStateParam(popularMovieListKey, _requestPopularMovies)));
    topRatedMovieList = _read(movieStateProvider(
        MoviesStateParam(topRatedMovieListKey, _requestTopRatedMovies)));

    _customMovieStateMap = _read(customMovieStateMapProvider);
  }

  Future<PagingResult<Movie>> _requestTrendingMovies(
      int page, List<Movie>? oldMovieList) async {
    return await _read(getTrendingMoviesUseCase).call(
        language: lang,
        page: page,
        apiVersion: 3,
        timeWindow: TimeWindow.day,
        oldMovieList: oldMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestPopularMovies(
      int page, List<Movie>? oldMovieList) async {
    return await _read(getPopularMoviesUseCase).call(
        language: lang,
        page: page,
        apiVersion: 3,
        region: region,
        timeWindow: TimeWindow.day,
        oldMovieList: oldMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestTopRatedMovies(
      int page, List<Movie>? oldMovieList) async {
    return await _read(getTopRatedMoviesUseCase).call(
        language: lang,
        page: page,
        apiVersion: 3,
        region: region,
        oldMovieList: oldMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestUpComingMovies(
      int page, List<Movie>? oldMovieList) async {
    return await _read(getUpComingMoviesUseCase).call(
        language: lang,
        page: page,
        apiVersion: 3,
        region: region,
        timeWindow: TimeWindow.day,
        oldMovieList: oldMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestCustomDiscoveredMovies({
    required String listKey,
    required String sortBy,
    required int page,
    required List<Movie>? oldMovieList,
    double? voteAverageGte,
    double? voteAverageLte,
    int? year,
    String? withGenres,
    String? withKeywords,
    String? withOriginalLanguage,
    String? withWatchMonetizationTypes,
    String? watchRegion,
  }) async {
    final customList = _customMovieStateMap[listKey];

    if (customList == null) {
      return PagingResult.failure(
          FailureReason.exception(CannotFindValueFromKeyException(
              "Searched any matched list based on the key,but couldn't find it.")),
          null);
    } else {
      return await _read(getDiscoveredMoviesUseCase).call(
          language: lang,
          page: page,
          includeAdult: false,
          sortBy: sortBy,
          apiVersion: 3,
          region: region,
          oldMovieList: oldMovieList,
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
    final matchedList = _customMovieStateMap[key];

    if (matchedList == null) {
      _customMovieStateMap[key] = MoviesState(
          (page, oldMovieList) => _requestCustomDiscoveredMovies(
              listKey: key,
              sortBy: sortBy,
              withGenres: withGenres,
              page: page,
              oldMovieList: oldMovieList),
          key);
      return true;
    } else {
      return false;
    }
  }

  MoviesState? getCustomMovieList(String key) {
    return _customMovieStateMap[key];
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

class DiscoverViewModelParam {
  final Language language;
  final Region region;

  const DiscoverViewModelParam({
    required this.language,
    required this.region,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscoverViewModelParam &&
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

  DiscoverViewModelParam copyWith({
    Language? language,
    Region? region,
  }) {
    return DiscoverViewModelParam(
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

  factory DiscoverViewModelParam.fromMap(Map<String, dynamic> map) {
    return DiscoverViewModelParam(
      language: map['language'] as Language,
      region: map['region'] as Region,
    );
  }
}
