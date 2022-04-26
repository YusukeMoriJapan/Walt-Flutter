import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';

import '../models/entity/movie.dart';
import '../utils/network/requests/get_movie_request.dart';
import '../utils/network/result.dart';

///TODO FIX CancelTokenを外部から注入できるようにしないといけない
final movieProvider =
    FutureProvider.family<Result<List<Movie>>, GetMovieRequestBase>(
        (ref, request) async {
  final token = CancelToken();
  ref.onDispose(() => token.cancel());

  return await ref.read(movieRepository).getDiscoveredMovies(
      language: request.language,
      page: request.page,
      apiVersion: request.apiVersion ?? 3,
      region: request.region,
      cancelToken: token);
});
