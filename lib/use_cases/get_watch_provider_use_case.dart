import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/region/region.dart';
import '../repository/watch_provider_repository.dart';
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
