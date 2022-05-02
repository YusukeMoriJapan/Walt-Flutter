import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';

import '../models/entity/movie/movie.dart';
import '../models/region/region.dart';
import '../utils/network/paging/paging_result.dart';
import '../utils/network/result.dart';

final getTrendingMoviesUseCase = Provider((ref) {
  return (
      {required Language language,
      required int page,
      required int apiVersion,
      required TimeWindow timeWindow,
      required List<Movie>? oldMovieList,
      required CancelToken cancelToken}) {
    return ref
        .read(movieRepository)
        .getTrendingMovies(
            language: language,
            page: page,
            apiVersion: apiVersion,
            timeWindow: timeWindow,
            cancelToken: cancelToken)
        .then<PagingResult<Movie>>((result) {
      /// TODO FIX 処理の共通化必要
      return result.when(success: (newMovieList) {
        if (oldMovieList != null) {
          return PagingSuccess([...oldMovieList, ...newMovieList]);
        } else {
          return PagingSuccess(newMovieList);
        }
      }, failure: (e) {
        return PagingFailure(e, oldMovieList);
      });
    });
  };
});

final getTopRatedMoviesUseCase = Provider((ref) {
  return (
      {required Language language,
      required int page,
      required int apiVersion,
      required Region region,
      required List<Movie>? oldMovieList,
      required CancelToken cancelToken}) {
    return ref
        .read(movieRepository)
        .getTopRatedMovies(
            language: language,
            page: page,
            apiVersion: apiVersion,
            region: region,
            cancelToken: cancelToken)
        .then<PagingResult<Movie>>((result) {
      /// TODO FIX 処理の共通化必要
      return result.when(success: (newMovieList) {
        if (oldMovieList != null) {
          return PagingSuccess([...oldMovieList, ...newMovieList]);
        } else {
          return PagingSuccess(newMovieList);
        }
      }, failure: (e) {
        return PagingFailure(e, oldMovieList);
      });
    });
  };
});

final getPopularMoviesUseCase = Provider((ref) {
  return (
      {required Language language,
      required int page,
      required int apiVersion,
      required Region region,
      required TimeWindow timeWindow,
      required List<Movie>? oldMovieList,
      required CancelToken cancelToken}) {
    return ref
        .read(movieRepository)
        .getPopularMovies(
            language: language,
            page: page,
            apiVersion: apiVersion,
            region: region,
            cancelToken: cancelToken)
        .then<PagingResult<Movie>>((result) {
      /// TODO FIX 処理の共通化必要
      return result.when(success: (newMovieList) {
        if (oldMovieList != null) {
          return PagingSuccess([...oldMovieList, ...newMovieList]);
        } else {
          return PagingSuccess(newMovieList);
        }
      }, failure: (e) {
        return PagingFailure(e, oldMovieList);
      });
    });
  };
});

final getUpComingMoviesUseCase = Provider((ref) {
  return (
      {required Language language,
      required int page,
      required int apiVersion,
      required Region region,
      required TimeWindow timeWindow,
      required List<Movie>? oldMovieList,
      required CancelToken cancelToken}) {
    return ref
        .read(movieRepository)
        .getUpComingMovies(
            language: language,
            page: page,
            apiVersion: apiVersion,
            region: region,
            cancelToken: cancelToken)
        .then<PagingResult<Movie>>((result) {
      /// TODO FIX 処理の共通化必要
      return result.when(success: (newMovieList) {
        if (oldMovieList != null) {
          return PagingSuccess([...oldMovieList, ...newMovieList]);
        } else {
          return PagingSuccess(newMovieList);
        }
      }, failure: (e) {
        return PagingFailure(e, oldMovieList);
      });
    });
  };
});
