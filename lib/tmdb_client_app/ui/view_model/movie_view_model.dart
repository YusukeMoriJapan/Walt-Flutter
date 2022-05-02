import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:walt/tmdb_client_app/models/region/region.dart';

import '../../models/entity/movie/movie.dart';
import '../../models/entity/movie/movie_list.dart';
import '../../repository/movie_repository.dart';
import '../../use_cases/get_movies_use_case.dart';
import '../../utils/network/paging/paging_result.dart';
import '../../utils/network/paging/paging_result.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final movieViewModelProvider =
    Provider.autoDispose((ref) => MovieViewModel(ref.read));

class MovieViewModel {
  final Reader _read;

  late final MovieList trendingMovieList;
  late final MovieList upComingMovieList;
  late final MovieList popularMovieList;
  late final MovieList topRatedMovieList;

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
}
