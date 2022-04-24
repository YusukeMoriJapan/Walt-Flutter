import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/models/config/tmdb_config.dart';
import 'package:walt/tmdb_client_app/models/responses/get_tmdb_config_result.dart';
import 'package:walt/tmdb_client_app/utils/utils.dart';

import 'client/tmdb_client.dart';

final tmdbConfigRepository =
    Provider<TmdbConfigRepository>((ref) => TmdbConfigRepositoryImpl(ref.read));

abstract class TmdbConfigRepository {
  Future<TmdbConfig> getTmdbConfig({required int apiVersion});
}

/// 追加予定
/// GET /genre/movie/list (ジャンル一覧取得)
/// 
class TmdbConfigRepositoryImpl implements TmdbConfigRepository {
  final Reader read;

  TmdbConfigRepositoryImpl(this.read);

  @override
  Future<TmdbConfig> getTmdbConfig(
      {required int apiVersion, CancelToken? cancelToken}) async {
    try {
      final response = await read(tmdbClientProvider)
          .get('/3/configuration?api_key=${getTmdbApiKey()}', cancelToken: cancelToken);

      final images = GetTmdbConfigResult.fromJson(response.data).images;
      if (images == null) {
        throw const HttpException("images is null");
      }
      final changeKeys = GetTmdbConfigResult.fromJson(response.data).changeKeys;
      if (changeKeys == null) {
        throw const HttpException("changeKeys is null");
      }

      return TmdbConfig(images, changeKeys);
    } on DioError catch (error) {
      rethrow;

      /// 何らかの例外を出す
    }
  }
}
