import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_metadata.freezed.dart';
part 'provider_metadata.g.dart';

@freezed
class ProviderMetadataList with _$ProviderMetadataList {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ProviderMetadataList(
      {required String? link,
        required List<ProviderMetadata>? flatrate,
        required List<ProviderMetadata>? buy,
        required List<ProviderMetadata>? rent}) = _ProviderMetadataList;

  factory ProviderMetadataList.fromJson(Map<String, dynamic> json) => _$ProviderMetadataListFromJson(json);
}

@freezed
class ProviderMetadata with _$ProviderMetadata {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ProviderMetadata(
      {required int? displayPriority,
        required String? logoPath,
        required int? providerId,
        required String? providerName}) = _ProviderMetadata;

  factory ProviderMetadata.fromJson(Map<String, dynamic> json) =>
      _$ProviderMetadataFromJson(json);
}
