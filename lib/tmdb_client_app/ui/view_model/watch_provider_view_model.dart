import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/models/region/region.dart';
import 'package:walt/tmdb_client_app/use_cases/get_watch_provider_use_case.dart';

import '../../models/entity/watch_provider/provider_metadata.dart';
import '../../utils/network/result.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final watchProviderViewModelProvider =
    Provider.autoDispose((ref) => WatchProviderViewModel(ref.read));

class WatchProviderViewModel {
  final Reader _read;

  WatchProviderViewModel(this._read);

  Future<Result<ProviderMetadataList>> getMovieWatchProvider(int movieId) =>
      _read(getMovieWatchProviderUseCase)(
          region: Region.japan,
          movieId: movieId,
          cancelToken: CancelToken(),
          apiVersion: 3);
}
