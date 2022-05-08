import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retry/retry.dart';
import 'package:walt/tmdb_client_app/data_sources/local/tmdb_config_local_data_source.dart';

import '../../utils/network/result.dart';

part 'tmdb_config.freezed.dart';
part 'tmdb_config.g.dart';

@freezed
class TmdbConfig with _$TmdbConfig {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TmdbConfig(
      {required TmdbImageConfig? images,
      required final List<String>? changeKeys}) = _TmdbConfig;

  factory TmdbConfig.fromJson(Map<String, dynamic> json) =>
      _$TmdbConfigFromJson(json);
}

@freezed
class TmdbImageConfig with _$TmdbImageConfig {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TmdbImageConfig({
    required String? baseUrl,
    required String? secureBaseUrl,
    required List<String>? backdropSizes,
    required List<String>? logoSizes,
    required List<String>? posterSizes,
    required List<String>? profileSizes,
    required List<String>? stillSizes,
  }) = _TmdbImageConfig;

  factory TmdbImageConfig.fromJson(Map<String, dynamic> json) =>
      _$TmdbImageConfigFromJson(json);
}

extension TmdbConfigEx on TmdbConfig {
  Result<TmdbConfig> toTmdbConfigResult(
      TmdbConfigLocalDataSource localDataSource, bool shouldStoreToLocal) {
    try {
      final images = this.images;
      final changeKeys = this.changeKeys;

      if (images == null) {
        ///TODO:FIX 自作エラーでラップする方が良い
        throw const HttpException(
            "Fetching process has been completed normally. but image config is null.");
      }

      if (changeKeys == null) {
        ///TODO:FIX 自作エラーでラップする方が良い
        throw const HttpException(
            "Fetching process has been completed normally. but changeKeys are null.");
      }

      if (shouldStoreToLocal) {
        const RetryOptions(maxAttempts: 3).retry(() {
          localDataSource
              .setTmdbConfig(this)
              .timeout(const Duration(seconds: 30));
        }, retryIf: (e) => true);
      }

      return Result.success(this);
    } catch (e) {
      return Result.failure(e.toFailureReason());
    }
  }
}
