import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:walt/tmdb_client_app/models/region/region.dart';

import '../../models/entity/movie.dart';
import '../../repository/movie_repository.dart';
import '../../use_cases/get_movies_use_case.dart';
import '../../utils/network/paging/paging_result.dart';
import '../../utils/network/paging/paging_result.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final movieViewModelProvider =
    Provider.autoDispose((ref) => MovieViewModel(ref.read));

class MovieViewModel {
  final Reader _read;

  /// streamの現在値を同期的に取得できないため、別変数で管理
  ///(stream.lastで現在値を取得しようとすると、StateError("Stream has already been listened to.")エラーが発生する)
  int _currentTrendingPage = 1;
  int _currentUpComingPage = 1;
  int _currentPopularPage = 1;
  int _currentTopRatedPage = 1;

  List<Movie>? _currentTrendingMovies;
  List<Movie>? _currentUpComingMovies;
  List<Movie>? _currentPopularMovies;
  List<Movie>? _currentTopRatedMovies;

  /// useStreamで初期値を与える時は、必ずuseStreamを実行した後にcontroller.addを実行すること
  final _trendingPagingController = BehaviorSubject<PagingResult<Movie>>();
  final _upComingPagingController = BehaviorSubject<PagingResult<Movie>>();
  final _popularPagingController = BehaviorSubject<PagingResult<Movie>>();
  final _topRatedPagingController = BehaviorSubject<PagingResult<Movie>>();

  late final Stream<PagingResult<Movie>> trendingMovieStream;
  late final Stream<PagingResult<Movie>> upComingMovieStream;
  late final Stream<PagingResult<Movie>> popularMovieStream;
  late final Stream<PagingResult<Movie>> topRatedMovieStream;

  MovieViewModel(this._read) {
    trendingMovieStream = _trendingPagingController.stream;
    upComingMovieStream = _upComingPagingController.stream;
    popularMovieStream = _popularPagingController.stream;
    topRatedMovieStream = _topRatedPagingController.stream;

    _requestTrendingMovies();
    _requestPopularMovies();
    _requestTopRatedMovies();
    _requestUpComingMovies();
  }

  _requestTrendingMovies() async {
    await _read(getTrendingMoviesUseCase)
        .call(
            language: Language.japanese,
            page: _currentTrendingPage,
            apiVersion: 3,
            timeWindow: TimeWindow.day,
            oldMovieList: _currentTrendingMovies,
            cancelToken: CancelToken())
        .then((value) {
      _trendingPagingController.value = value;
      _currentTrendingMovies = value.when(
          success: (data) => data, failure: (reason, oldList) => oldList);
    });
  }

  _requestPopularMovies() async {
    await _read(getPopularMoviesUseCase)
        .call(
            language: Language.japanese,
            page: _currentPopularPage,
            apiVersion: 3,
            region: Region.japan,
            timeWindow: TimeWindow.day,
            oldMovieList: _currentPopularMovies,
            cancelToken: CancelToken())
        .then((value) {
      _popularPagingController.value = value;
      _currentPopularMovies = value.when(
          success: (data) => data, failure: (reason, oldList) => oldList);
    });
  }

  _requestTopRatedMovies() async {
    await _read(getTopRatedMoviesUseCase)
        .call(
            language: Language.japanese,
            page: _currentTopRatedPage,
            apiVersion: 3,
            region: Region.japan,
            oldMovieList: _currentTopRatedMovies,
            cancelToken: CancelToken())
        .then((value) {
      _topRatedPagingController.value = value;
      _currentTopRatedMovies = value.when(
          success: (data) => data, failure: (reason, oldList) => oldList);
    });
  }

  _requestUpComingMovies() async {
    await _read(getUpComingMoviesUseCase)
        .call(
            language: Language.japanese,
            page: _currentUpComingPage,
            apiVersion: 3,
            region: Region.japan,
            timeWindow: TimeWindow.day,
            oldMovieList: _currentUpComingMovies,
            cancelToken: CancelToken())
        .then((value) {
      _upComingPagingController.value = value;
      _currentUpComingMovies = value.when(
          success: (data) => data, failure: (reason, oldList) => oldList);
    });
  }

  List<Movie>? getCurrentTrendingMovies() => _currentTrendingMovies;

  List<Movie>? getCurrentUpComingMovies() => _currentUpComingMovies;

  List<Movie>? getCurrentTopRatedMovies() => _currentTopRatedMovies;

  List<Movie>? getCurrentPopularMovies() => _currentPopularMovies;

  bool get currentTrendingMoviesAreNull =>
      _currentTrendingMovies?.isEmpty ?? true;

  bool get currentUpComingMoviesAreNull =>
      _currentUpComingMovies?.isEmpty ?? true;

  bool get currentTopRatedMoviesAreNull =>
      _currentTopRatedMovies?.isEmpty ?? true;

  bool get currentPopularMoviesAreNull =>
      _currentPopularMovies?.isEmpty ?? true;

  requestNextPageTrendingMovies() {
    _currentTrendingPage++;
    _requestTrendingMovies();
  }

  refreshTrendingMovies() {
    _currentTrendingPage = 1;
    _currentTrendingMovies = null;
    _requestTrendingMovies();
  }

  refreshUpComingMovies() {
    _currentUpComingPage = 1;
    _currentUpComingMovies = null;
    _requestUpComingMovies();
  }

  refreshTopRatedMovies() {
    _currentTopRatedPage = 1;
    _currentTopRatedMovies = null;
    _requestTopRatedMovies();
  }

  refreshPopularMovies() {
    _currentPopularPage = 1;
    _currentPopularMovies = null;
    _requestPopularMovies();
  }
}
