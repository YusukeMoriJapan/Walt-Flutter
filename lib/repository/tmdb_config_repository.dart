import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retry/retry.dart';
import 'package:walt/models/config/tmdb_config.dart';
import 'package:walt/providers/tmdb_config_local_data_source_provider.dart';
import 'package:walt/utils/network/requests/retry.dart';
import 'package:walt/utils/utils.dart';

import '../data_sources/local/tmdb_config_local_data_source.dart';
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
      {required int apiVersion, required CancelToken cancelToken}) async {
    final localSource = read(tmdbConfigLocalDataSourceProvider);
    final lastTimeSetToLocal = await localSource.getLastTimeSetTmdbConfig();
    final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch;

    if (_shouldReadFromLocal(currentTime, lastTimeSetToLocal)) {
      final localCache = await localSource.getTmdbConfig();

      if (localCache == null) {
        return _readFromRemote(
            apiVersion: apiVersion,
            cancelToken: cancelToken,
            localSource: localSource);
      }

      return localCache.toTmdbConfigResult(localSource, false);
    }

    return _readFromRemote(
        apiVersion: apiVersion,
        cancelToken: cancelToken,
        localSource: localSource);
  }

  Future<Result<TmdbConfig>> _readFromRemote(
      {required int apiVersion,
      required CancelToken cancelToken,
      required TmdbConfigLocalDataSource localSource}) {
    return read(tmdbClientProvider)
        .getTmdbConfig(apiVersion, getTmdbApiKey(), cancelToken)
        .httpDioRetry(
            retryOptions: const RetryOptions(maxAttempts: 3),
            timeoutDuration: const Duration(seconds: 10))
        .then((response) {
      return response.toTmdbConfigResult(localSource, true);
    });
  }

  bool _shouldReadFromLocal(int currentTimeMillis, int? lastTimeSetToLocal) =>
      (lastTimeSetToLocal != null &&
          currentTimeMillis - lastTimeSetToLocal >
              const Duration(days: 3).inMicroseconds);
}
