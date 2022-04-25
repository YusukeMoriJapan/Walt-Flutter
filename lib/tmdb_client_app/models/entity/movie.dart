import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';

part 'movie.g.dart';

@freezed
class Movie with _$Movie {

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Movie({
    required String? backdropPath,
    required String? firstAirDate,
    required List<num>? genreIds,
    required num? id,
    required String? name,
    required List<String>? originCountry,
    required String? originalLanguage,
    required String? originalName,
    required String? overview,
    required num? popularity,
    required String? posterPath,
    required num? voteAverage,
    required num? voteCount,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json)
  => _$MovieFromJson(json);
}