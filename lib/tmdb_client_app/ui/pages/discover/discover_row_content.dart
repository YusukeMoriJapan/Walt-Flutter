import 'package:flutter/cupertino.dart';

import '../../../models/entity/movie/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_row_content.freezed.dart';

@freezed
abstract class DiscoverRowContent with _$DiscoverRowContent {
  const factory DiscoverRowContent.normal(List<Widget> value) = Normal;
  const factory DiscoverRowContent.highlighted(List<Widget> value) = Highlighted;
  const factory DiscoverRowContent.some(List<Widget> value) = Some;
}