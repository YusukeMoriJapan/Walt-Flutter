import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retry/retry.dart';
import 'package:walt/tmdb_client_app/models/entity/watch_provider/provider_metadata.dart';
import 'package:walt/tmdb_client_app/utils/network/requests/retry.dart';
import 'package:walt/tmdb_client_app/utils/utils.dart';

import '../models/region/region.dart';
import '../providers/tmdb_client_provider.dart';
import '../utils/network/result.dart';

final watchProviderRepository = Provider<WatchProviderRepository>(
    (ref) => WatchProviderRepositoryImpl(ref.read));

abstract class WatchProviderRepository {
  Future<Result<ProviderMetadataList>> getMovieWatchProvider(
      {required Region region,
      required int apiVersion,
      required int movieId,
      required CancelToken cancelToken});
}

class WatchProviderRepositoryImpl implements WatchProviderRepository {
  final Reader read;

  WatchProviderRepositoryImpl(this.read);

  @override
  Future<Result<ProviderMetadataList>> getMovieWatchProvider(
      {required Region region,
      required int apiVersion,
      required int movieId,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getMovieWatchProvider(
            apiVersion, getTmdbApiKey(), movieId, cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      try {
        if (region == Region.japan) {
          final metadata = response.results?.jp;
          if (metadata == null) {
            ///TODO FIX 独自例外に置き換える
            throw const HttpException("null");
          }

          return Result.success(metadata);
        } else {
          final metadata = response.results?.us;
          if (metadata == null) {
            ///TODO FIX　独自例外に置き換える
            throw const HttpException("null");
          }

          return Result.success(metadata);
        }
      } catch (e) {
        return Result.failure(e.toFailureReason());
      }
    });
  }
}
