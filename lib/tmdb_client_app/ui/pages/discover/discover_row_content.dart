import '../../../models/entity/movie/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_row_content.freezed.dart';

@freezed
abstract class DiscoverRowContent with _$DiscoverRowContent {
  const factory DiscoverRowContent.normal(List<Movie> value) = Normal;
  const factory DiscoverRowContent.highlighted(List<Movie> value) = Highlighted;
  const factory DiscoverRowContent.some(List<Movie> value) = some;
}