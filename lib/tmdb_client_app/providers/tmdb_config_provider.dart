import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/models/config/tmdb_config.dart';
import 'package:walt/tmdb_client_app/repository/tmdb_config_repository.dart';

import '../utils/network/result.dart';

///TODO FIX CancelTokenを外部から注入できるようにしないといけない
final tmdbConfigProvider = FutureProvider<Result<TmdbConfig>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() {
    cancelToken.cancel();
  });

  return await ref
      .read(tmdbConfigRepository)
      .getTmdbConfig(apiVersion: 3, cancelToken: cancelToken);
});
