import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/watch_provider_repository.dart';

import '../models/entity/movie.dart';
import '../models/entity/watch_provider/provider_metadata.dart';
import '../models/region/region.dart';
import '../repository/movie_repository.dart';
import '../utils/network/paging/paging_result.dart';
import '../utils/network/result.dart';

final getMovieWatchProviderUseCase = Provider((ref) {
  return (
      {required Region region,
      required int apiVersion,
      required int movieId,
      required CancelToken cancelToken}) {
    return ref.read(watchProviderRepository).getMovieWatchProvider(
        region: region,
        apiVersion: apiVersion,
        movieId: movieId,
        cancelToken: cancelToken);
  };
});
