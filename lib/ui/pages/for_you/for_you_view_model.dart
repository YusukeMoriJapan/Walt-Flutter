import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/movie_constant.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../models/entity/watch_provider/provider_metadata.dart';
import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';
import '../../../use_cases/get_movies_use_case.dart';
import '../../../use_cases/get_watch_provider_use_case.dart';
import '../../../utils/network/paging/paging_result.dart';
import '../../../utils/network/result.dart';
import '../../states/movie_list.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final forYouViewModelProvider = Provider.autoDispose
    .family<ForYouViewModel, ForYouViewModelParam>(
        (ref, param) => ForYouViewModel(ref.watch, param.language, param.region));

class ForYouViewModel {
  final Reader _read;
  final Language lang;
  final Region region;

  late final MoviesState trendingMovies;
  late final MoviesState upComingMovies;
  late final MoviesState popularMovies;
  late final MoviesState topRatedMovies;

  ForYouViewModel(this._read, this.lang, this.region) {
    trendingMovies = _read(movieStateProvider(
        MoviesStateParam(trendingMovieListKey, _requestTrendingMovies)));
    upComingMovies = _read(movieStateProvider(
        MoviesStateParam(upComingMovieListKey, _requestUpComingMovies)));
    popularMovies = _read(movieStateProvider(
        MoviesStateParam(popularMovieListKey, _requestPopularMovies)));
    topRatedMovies = _read(movieStateProvider(
        MoviesStateParam(topRatedMovieListKey, _requestTopRatedMovies)));
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
    return null;
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
  }

  Future<Result<ProviderMetadataList>> getMovieWatchProvider(int movieId) =>
      _read(getMovieWatchProviderUseCase)(
          region: region,
          movieId: movieId,
          cancelToken: CancelToken(),
          apiVersion: 3);
}

class ForYouViewModelParam {
  final Language language;
  final Region region;

  const ForYouViewModelParam({
    required this.language,
    required this.region,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ForYouViewModelParam &&
              runtimeType == other.runtimeType &&
              language == other.language &&
              region == other.region);

  @override
  int get hashCode => language.hashCode ^ region.hashCode;

  @override
  String toString() {
    return 'MovieViewModelParam{ language: $language, region: $region,}';
  }

  ForYouViewModelParam copyWith({
    Language? language,
    Region? region,
  }) {
    return ForYouViewModelParam(
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

  factory ForYouViewModelParam.fromMap(Map<String, dynamic> map) {
    return ForYouViewModelParam(
      language: map['language'] as Language,
      region: map['region'] as Region,
    );
  }
}
