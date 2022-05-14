import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/entity/watch_provider/provider_metadata.dart';
import '../../models/region/region.dart';
import '../../use_cases/get_watch_provider_use_case.dart';
import '../../utils/network/result.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final watchProviderViewModelProvider = Provider.autoDispose
    .family<WatchProviderViewModel, Region>(
        (ref, param) => WatchProviderViewModel(ref.read, param));

class WatchProviderViewModel {
  final Reader _read;
  final Region region;

  WatchProviderViewModel(this._read, this.region);

  Future<Result<ProviderMetadataList>> getMovieWatchProvider(int movieId) =>
      _read(getMovieWatchProviderUseCase)(
          region: region,
          movieId: movieId,
          cancelToken: CancelToken(),
          apiVersion: 3);
}
