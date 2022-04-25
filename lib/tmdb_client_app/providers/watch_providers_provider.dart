import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/models/entity/watch_provider/provider_metadata.dart';
import 'package:walt/tmdb_client_app/models/region/region.dart';
import 'package:walt/tmdb_client_app/repository/watch_provider_repository.dart';

import '../utils/network/result.dart';

///TODO FIX CancelTokenを外部から注入できるようにしないといけない
final movieWatchProviderProvider =
    FutureProvider.family<Result<ProviderMetadataList>, int>((ref, id) async {
  final token = CancelToken();
  ref.onDispose(() => token.cancel());

  return await ref.read(watchProviderRepository).getMovieWatchProvider(
      region: Region.japan, apiVersion: 3, movieId: id, cancelToken: token);
});
