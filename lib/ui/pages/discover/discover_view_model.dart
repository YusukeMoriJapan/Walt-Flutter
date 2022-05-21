import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/movie_constant.dart';
import 'package:walt/ui/view_model/movies_state_view_model.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';
import '../../../use_cases/get_movies_use_case.dart';
import '../../../utils/network/paging/paging_result.dart';
import '../../states/movies_state.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final discoverViewModelProvider = Provider.autoDispose
    .family<DiscoverViewModel, DiscoverViewModelParam>((ref, param) =>
        DiscoverViewModel(ref.watch, param.language, param.region));

class DiscoverViewModel with MoviesStateViewModel {
  final Reader _read;
  final Language lang;
  final Region region;

  DiscoverViewModel(this._read, this.lang, this.region) {
    trendingMovies = _read(movieStateProvider(
        MoviesStateParam(trendingMovieListKey, _requestTrendingMovies)));
    upComingMovies = _read(movieStateProvider(
        MoviesStateParam(upComingMovieListKey, _requestUpComingMovies)));
    popularMovies = _read(movieStateProvider(
        MoviesStateParam(popularMovieListKey, _requestPopularMovies)));
    topRatedMovies = _read(movieStateProvider(
        MoviesStateParam(topRatedMovieListKey, _requestTopRatedMovies)));

    customMoviesMap = _read(customMovieStateMapProvider);
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
    final matchedList = customMoviesMap[key];

    if (matchedList == null) {
      customMoviesMap[key] = MoviesState(
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
