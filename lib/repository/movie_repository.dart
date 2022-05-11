import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retry/retry.dart';
import 'package:walt/models/entity/movie/movie_detail/movie_details.dart';
import 'package:walt/models/region/region.dart';
import 'package:walt/models/request/append_to_response.dart';
import 'package:walt/utils/network/requests/retry.dart';
import 'package:walt/utils/network/result.dart';
import 'package:walt/utils/utils.dart';

import '../models/entity/movie/movie.dart';
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
      required Region region,
      required CancelToken cancelToken});

  Future<Result<List<Movie>>> getTrendingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required TimeWindow timeWindow,
      required CancelToken cancelToken});

  Future<Result<List<Movie>>> getTopRatedMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required Region region,
      required CancelToken cancelToken});

  Future<Result<List<Movie>>> getUpComingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required Region region,
      required CancelToken cancelToken});

  Future<Result<List<Movie>>> getDiscoveredMovies({
    required Language language,
    required int page,
    required int apiVersion,
    required Region region,
    required CancelToken cancelToken,
    required bool includeAdult,
    required String sortBy,
    double? voteAverageGte,
    double? voteAverageLte,
    int? year,
    String? withGenres,
    String? withKeywords,
    String? withOriginalLanguage,
    String? withWatchMonetizationTypes,
    String? watchRegion,
  });

  Future<Result<MovieDetails>> getMovieDetails(
      {required Language language,
      required int apiVersion,
      required int movieId,
      required AppendToResponse? appendToResponse,
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
      required Region region,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getPopularMovies(page, language.name, apiVersion, region.name,
            getTmdbApiKey(), cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<List<Movie>>> getTrendingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required TimeWindow timeWindow,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getTrendingMovies(apiVersion, timeWindow.name, getTmdbApiKey(),
            language.name, page, cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<List<Movie>>> getTopRatedMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required Region region,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getTopRatedMovies(apiVersion, getTmdbApiKey(), language.name,
            region.name, page, cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<List<Movie>>> getUpComingMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required Region region,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getUpComingMovies(page, language.name, apiVersion, region.name,
            getTmdbApiKey(), cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<List<Movie>>> getDiscoveredMovies({
    required Language language,
    required int page,
    required int apiVersion,
    required Region region,
    required CancelToken cancelToken,
    required bool includeAdult,
    required String sortBy,
    double? voteAverageGte,
    double? voteAverageLte,
    int? year,
    String? withGenres,
    String? withKeywords,
    String? withOriginalLanguage,
    String? withWatchMonetizationTypes,
    String? watchRegion,
  }) {
    return read(tmdbClientProvider)
        .getDiscoveredMovies(page, apiVersion, getTmdbApiKey(), language.name,
            region.name, includeAdult.toString(), sortBy, cancelToken,
            voteAverageGte: voteAverageGte,
            voteAverageLte: voteAverageLte,
            year: year,
            withGenres: withGenres,
            withKeywords: withKeywords,
            withOriginalLanguage: withOriginalLanguage,
            withWatchMonetizationTypes: withWatchMonetizationTypes,
            watchRegion: watchRegion)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return response.toMoviesResult();
    });
  }

  @override
  Future<Result<MovieDetails>> getMovieDetails(
      {required Language language,
      required int apiVersion,
      required int movieId,
      required AppendToResponse? appendToResponse,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getMovieDetails(apiVersion, movieId, getTmdbApiKey(), language.name,
            appendToResponse.toString(), cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return Result.success(response);
    }).catchError((Object e, StackTrace stackTrace) {
      return Result<MovieDetails>.failure(e.toFailureReason());
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
