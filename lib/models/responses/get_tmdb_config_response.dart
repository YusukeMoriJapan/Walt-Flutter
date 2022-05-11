import 'package:freezed_annotation/freezed_annotation.dart';

import '../config/tmdb_config.dart';

part 'get_tmdb_config_response.freezed.dart';
part 'get_tmdb_config_response.g.dart';

@freezed
class GetTmdbConfigResult with _$GetTmdbConfigResult {

  const factory GetTmdbConfigResult({
    required TmdbImageConfig? images,
    required List<String>? changeKeys
  }) = _GetTmdbConfigResult;

  factory GetTmdbConfigResult.fromJson(Map<String, dynamic> json) =>
      _$GetTmdbConfigResultFromJson(json);
}