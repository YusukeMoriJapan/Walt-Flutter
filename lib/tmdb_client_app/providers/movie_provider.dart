import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';
import '../models/responses/get_movies_result.dart';

final movieProvider = FutureProvider<List<Movie>?>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  return await ref.read(movieRepository).getPopularMovies(
      language: Language.japanese, page: 1, apiVersion: 3, region: "");
});
