import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/movie_constant.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';
import '../../../use_cases/get_movies_use_case.dart';
import '../../../utils/network/paging/paging_result.dart';
import '../../states/movie_list.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final discoverViewModelProvider = Provider.autoDispose
    .family<DiscoverViewModel, DiscoverViewModelParam>((ref, param) =>
        DiscoverViewModel(ref.watch, param.language, param.region));

class DiscoverViewModel {
  final Reader _read;
  final Language lang;
  final Region region;

  late final MoviesState trendingMovies;
  late final MoviesState upComingMovies;
  late final MoviesState popularMovies;
  late final MoviesState topRatedMovies;

  late final Map<String, MoviesState> _customMoviesMap;

  DiscoverViewModel(this._read, this.lang, this.region) {
    trendingMovies = _read(movieStateProvider(
        MoviesStateParam(trendingMovieListKey, _requestTrendingMovies)));
    upComingMovies = _read(movieStateProvider(
        MoviesStateParam(upComingMovieListKey, _requestUpComingMovies)));
    popularMovies = _read(movieStateProvider(
        MoviesStateParam(popularMovieListKey, _requestPopularMovies)));
    topRatedMovies = _read(movieStateProvider(
        MoviesStateParam(topRatedMovieListKey, _requestTopRatedMovies)));

    _customMoviesMap = _read(customMovieStateMapProvider);
  }

  requestNextPageMovies(String key) {
    switch (key) {
      case trendingMovieListKey:
        trendingMovies.requestNextPageMovieList();
        break;
      case popularMovieListKey:
        popularMovies.requestNextPageMovieList();
        break;
      case topRatedMovieListKey:
        topRatedMovies.requestNextPageMovieList();
        break;
      case upComingMovieListKey:
        upComingMovies.requestNextPageMovieList();
        break;
    }
    _customMoviesMap[key]?.requestNextPageMovieList();
  }

  setMoviesStateCurrentIndex(String key, int index) {
    switch (key) {
      case trendingMovieListKey:
        trendingMovies.currentIndex = index;
        break;
      case popularMovieListKey:
        popularMovies.currentIndex = index;
        break;
      case topRatedMovieListKey:
        topRatedMovies.currentIndex = index;
        break;
      case upComingMovieListKey:
        upComingMovies.currentIndex = index;
        break;
    }
    _customMoviesMap[key]?.currentIndex = index;
  }

  Future<PagingResult<Movie>> _requestTrendingMovies(
      int page, List<Movie>? oldMovieList) async {
    return await _read(getTrendingMoviesPagingUseCase).call(
        language: lang,
        page: page,
        apiVersion: 3,
        timeWindow: TimeWindow.day,
        oldMovieList: oldMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestPopularMovies(
      int page, List<Movie>? oldMovieList) async {
    return await _read(getPopularMoviesPagingUseCase).call(
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
    return await _read(getTopRatedMoviesPagingUseCase).call(
        language: lang,
        page: page,
        apiVersion: 3,
        region: region,
        oldMovieList: oldMovieList,
        cancelToken: CancelToken());
  }

  Future<PagingResult<Movie>> _requestUpComingMovies(
      int page, List<Movie>? oldMovieList) async {
    return await _read(getUpComingMoviesPagingUseCase).call(
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
    return await _read(getDiscoveredMoviesPagingUseCase).call(
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

  bool registerCustomDiscoveredMovieList(
    String key,
    String? withGenres,
    String sortBy,
  ) {
    final matchedList = _customMoviesMap[key];

    if (matchedList == null) {
      _customMoviesMap[key] = MoviesState(
          (page, oldMovieList) => _requestCustomDiscoveredMovies(
              listKey: key,
              sortBy: sortBy,
              withGenres: withGenres,
              page: page,
              oldMovieList: oldMovieList),
          key)
        ..refreshMovieList();
      return true;
    } else {
      return false;
    }
  }

  MoviesState? getMoviesStateFromKey(String key) {
    switch (key) {
      case trendingMovieListKey:
        return trendingMovies;
        break;
      case popularMovieListKey:
        return popularMovies;
        break;
      case topRatedMovieListKey:
        return topRatedMovies;
        break;
      case upComingMovieListKey:
        return upComingMovies;
        break;
    }
    return _customMoviesMap[key];
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
    return 'MovieViewModelParam{ language: $language, region: $region,}';
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
