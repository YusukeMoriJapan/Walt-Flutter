import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walt/tmdb_client_app/models/entity/watch_provider/provider_metadata.dart';

part 'get_watch_provider_response.freezed.dart';
part 'get_watch_provider_response.g.dart';

@freezed
class GetWatchProviderResponse with _$GetWatchProviderResponse {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory GetWatchProviderResponse(
      {required int? id,
      required Results? results}) = _GetWatchProviderResponse;

  factory GetWatchProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$GetWatchProviderResponseFromJson(json);
}

@freezed
class Results with _$Results {
  @JsonSerializable(explicitToJson: true)
  const factory Results(
      {@JsonKey(name: 'US') required ProviderMetadataList? us,
      @JsonKey(name: 'JP') required ProviderMetadataList? jp}) = _Results;

  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);
}