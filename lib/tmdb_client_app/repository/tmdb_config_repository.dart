import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retry/retry.dart';
import 'package:walt/tmdb_client_app/models/config/tmdb_config.dart';
import 'package:walt/tmdb_client_app/utils/network/requests/retry.dart';
import 'package:walt/tmdb_client_app/utils/utils.dart';

import '../providers/tmdb_client_provider.dart';
import '../utils/network/result.dart';

final tmdbConfigRepository =
    Provider<TmdbConfigRepository>((ref) => TmdbConfigRepositoryImpl(ref.read));

abstract class TmdbConfigRepository {
  Future<Result<TmdbConfig>> getTmdbConfig(
      {required int apiVersion, required CancelToken cancelToken});
}

/// 追加予定
/// GET /genre/movie/list (ジャンル一覧取得)
///
class TmdbConfigRepositoryImpl implements TmdbConfigRepository {
  final Reader read;

  TmdbConfigRepositoryImpl(this.read);

  @override
  Future<Result<TmdbConfig>> getTmdbConfig(
      {required int apiVersion, required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getTmdbConfig(apiVersion, getTmdbApiKey(), cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return response.toTmdbConfigResult();
    });
  }
}
