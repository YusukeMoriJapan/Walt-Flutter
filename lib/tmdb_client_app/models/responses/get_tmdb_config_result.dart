import '../config/tmdb_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_tmdb_config_result.freezed.dart';
part 'get_tmdb_config_result.g.dart';

@freezed
class GetTmdbConfigResult with _$GetTmdbConfigResult {

  const factory GetTmdbConfigResult({
    required TmdbImageConfig? images,
    required List<String>? changeKeys
  }) = _GetTmdbConfigResult;

  factory GetTmdbConfigResult.fromJson(Map<String, dynamic> json) =>
      _$GetTmdbConfigResultFromJson(json);
}