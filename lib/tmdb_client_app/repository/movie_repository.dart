import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/utils/network/result.dart';
import 'package:walt/tmdb_client_app/utils/utils.dart';

import '../models/entity/movie.dart';
import '../models/responses/get_movie_response.dart';
import '../providers/tmdb_client_provider.dart';

final movieRepository =
    Provider<MovieRepository>((ref) => MovieRepositoryImpl(ref.read));

///　追加予定API
/// now_playing (上映中)
/// latest(最近追加された映画)
/// similar(指定映画とよく似た映画)、
/// recommendations(指定映画と似ている映画)
/// discover(特定条件に一致する映画)
///
abstract class MovieRepository {
  Future<Result<List<Movie>>> getPopularMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required CancelToken cancelToken});

  Future<Result<List<Movie>>> getTrendingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required TimeWindow timeWindow,
      required CancelToken cancelToken});

  Future<Result<List<Movie>>> getTopRatedMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required CancelToken cancelToken});

  Future<Result<List<Movie>>> getUpComingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required CancelToken cancelToken});
}

class MovieRepositoryImpl implements MovieRepository {
  final Reader read;

  MovieRepositoryImpl(this.read);

  @override
  Future<Result<List<Movie>>> getPopularMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getPopularMovies(3, getTmdbApiKey(), cancelToken)
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<List<Movie>>> getTrendingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required TimeWindow timeWindow,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getTrendingMovies(3, timeWindow.name, getTmdbApiKey(), cancelToken)
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<List<Movie>>> getTopRatedMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getTopRatedMovies(3, getTmdbApiKey(), cancelToken)
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<List<Movie>>> getUpComingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getUpComingMovies(3, getTmdbApiKey(), cancelToken)
        .then((response) {
      return response.toMoviesResult();
    });
  }
}

enum Language { japanese, englishUs }

extension LanguageEx on Language {
  String get name {
    switch (this) {
      case Language.englishUs:
        return 'en-US';
      case Language.japanese:
        return 'ja';
    }
  }
}

enum TimeWindow { day, week }

extension TimeWondowEx on TimeWindow {
  String get name {
    switch (this) {
      case TimeWindow.day:
        return 'day';
      case TimeWindow.week:
        return 'week';
    }
  }
}
