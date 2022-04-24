import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/constants.dart';
import 'package:walt/tmdb_client_app/utils/utils.dart';

import '../models/responses/get_movies_result.dart';
import 'client/tmdb_client.dart';

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
  Future<List<Movie>> getPopularMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region});

  Future<List<Movie>> getTrendingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required TimeWindow timeWindow});

  Future<List<Movie>> getTopRatedMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region});

  Future<List<Movie>> getUpComingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region});
}

class MovieRepositoryImpl implements MovieRepository {
  final Reader read;

  MovieRepositoryImpl(this.read);

  @override
  Future<List<Movie>> getPopularMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      CancelToken? cancelToken}) async {
    try {
      final response = await read(tmdbClientProvider).get(
          '/3/tv/popular?api_key=${getTmdbApiKey()}',
          cancelToken: cancelToken);
      final movies = GetMoviesResult.fromJson(response.data).results;

      if (movies == null) {
        throw HttpException("failed to fetch Trending movies.");
      }
      return movies;
    } on DioError catch (error) {
      rethrow;

      /// 何らかの例外を出す
    }
  }

  @override
  Future<List<Movie>> getTrendingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required TimeWindow timeWindow,
      CancelToken? cancelToken}) async {
    try {
      final response = await read(tmdbClientProvider).get(
          '/3/trending/movie/${timeWindow.name}?api_key=${getTmdbApiKey()}',
          cancelToken: cancelToken);

      final movies = GetMoviesResult.fromJson(response.data).results;

      if (movies == null) {
        throw HttpException("failed to fetch Trending movies.");
      }
      return movies;
    } on DioError catch (error) {
      rethrow;

      /// 何らかの例外を出す
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      CancelToken? cancelToken}) async {
    try {
      final response = await read(tmdbClientProvider).get(
          '/3/movie/top_rated?api_key=${getTmdbApiKey()}',
          cancelToken: cancelToken);

      final movies = GetMoviesResult.fromJson(response.data).results;

      if (movies == null) {
        throw HttpException("failed to fetch Trending movies.");
      }
      return movies;
    } on DioError catch (error) {
      rethrow;

      /// 何らかの例外を出す
    }
  }

  @override
  Future<List<Movie>> getUpComingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      CancelToken? cancelToken}) async {
    try {
      final response = await read(tmdbClientProvider).get(
          '/3/movie/upcoming?api_key=${getTmdbApiKey()}',
          cancelToken: cancelToken);

      final movies = GetMoviesResult.fromJson(response.data).results;

      if (movies == null) {
        throw HttpException("failed to fetch Trending movies.");
      }
      return movies;
    } on DioError catch (error) {
      rethrow;

      /// 何らかの例外を出す
    }
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
