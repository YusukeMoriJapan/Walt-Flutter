import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/repository/movie_repository.dart';
import 'package:walt/use_cases/create_paging_result_use_case.dart';

import '../models/entity/movie/movie.dart';
import '../models/region/region.dart';
import '../utils/network/paging/paging_result.dart';

final getTrendingMoviesPagingUseCase = Provider((ref) {
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
      return ref.watch(createPagingResultUseCase)(
          result: result, oldMovieList: oldMovieList);
    });
  };
});

final getTopRatedMoviesPagingUseCase = Provider((ref) {
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
      return ref.watch(createPagingResultUseCase)(
          result: result, oldMovieList: oldMovieList);
    });
  };
});

final getPopularMoviesPagingUseCase = Provider((ref) {
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
      return ref.watch(createPagingResultUseCase)(
          result: result, oldMovieList: oldMovieList);
    });
  };
});

final getUpComingMoviesPagingUseCase = Provider((ref) {
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
      return ref.watch(createPagingResultUseCase)(
          result: result, oldMovieList: oldMovieList);
    });
  };
});

final getDiscoveredMoviesPagingUseCase = Provider((ref) {
  return ({
    required Language language,
    required int page,
    required int apiVersion,
    required Region region,
    required CancelToken cancelToken,
    required bool includeAdult,
    required String sortBy,
    required List<Movie>? oldMovieList,
    double? voteAverageGte,
    double? voteAverageLte,
    int? year,
    String? withGenres,
    String? withKeywords,
    String? withOriginalLanguage,
    String? withWatchMonetizationTypes,
    String? watchRegion,
  }) {
    return ref
        .read(movieRepository)
        .getDiscoveredMovies(
            language: language,
            page: page,
            apiVersion: apiVersion,
            region: region,
            cancelToken: cancelToken,
            includeAdult: includeAdult,
            sortBy: sortBy,
            voteAverageLte: voteAverageLte,
            voteAverageGte: voteAverageGte,
            year: year,
            withGenres: withGenres,
            withKeywords: withKeywords,
            withOriginalLanguage: withOriginalLanguage,
            withWatchMonetizationTypes: withWatchMonetizationTypes,
            watchRegion: watchRegion)
        .then<PagingResult<Movie>>((result) {
      return ref.watch(createPagingResultUseCase)(
          result: result, oldMovieList: oldMovieList);
    });
  };
});
