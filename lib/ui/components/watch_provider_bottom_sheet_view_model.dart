import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/entity/watch_provider/provider_metadata.dart';
import '../../../models/region/region.dart';
import '../../../use_cases/get_watch_provider_use_case.dart';
import '../../../utils/network/result.dart';

final watchProviderViewModelProvider = Provider.autoDispose
    .family<WatchProviderViewModel, WatchProviderViewModelParam>((ref, param) =>
        WatchProviderViewModel(ref.watch, param.region));

class WatchProviderViewModel {
  final Reader _read;
  final Region region;

  WatchProviderViewModel(this._read,this.region);

  Future<Result<ProviderMetadataList>> getMovieWatchProvider(int movieId) =>
      _read(getMovieWatchProviderUseCase)(
          region: region,
          movieId: movieId,
          cancelToken: CancelToken(),
          apiVersion: 3);
}

class WatchProviderViewModelParam {
  final Region region;

  const WatchProviderViewModelParam({
    required this.region,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchProviderViewModelParam &&
          runtimeType == other.runtimeType &&
          region == other.region);

  @override
  int get hashCode => region.hashCode;

  @override
  String toString() {
    return 'WatchProviderViewModelParam{ region: $region,}';
  }

  WatchProviderViewModelParam copyWith({
    Region? region,
  }) {
    return WatchProviderViewModelParam(
      region: region ?? this.region,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'region': region,
    };
  }

  factory WatchProviderViewModelParam.fromMap(Map<String, dynamic> map) {
    return WatchProviderViewModelParam(
      region: map['region'] as Region,
    );
  }
}
