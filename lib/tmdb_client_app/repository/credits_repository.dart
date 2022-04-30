import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/models/entity/people/credits.dart';

import '../providers/tmdb_client_provider.dart';
import '../utils/network/result.dart';
import '../utils/utils.dart';

final creditsRepository =
    Provider<CreditsRepository>((ref) => CreditsRepositoryImpl(ref.read));

abstract class CreditsRepository {
  Future<Result<Credits>> getMovieCredits(
      {required int movieId,
      required int apiVersion,
      required CancelToken cancelToken});
}

class CreditsRepositoryImpl implements CreditsRepository {
  final Reader read;

  CreditsRepositoryImpl(this.read);

  @override
  Future<Result<Credits>> getMovieCredits(
      {required int movieId,
      required int apiVersion,
      required CancelToken cancelToken}) {
    return read(tmdbClientProvider)
        .getMovieCredits(apiVersion, movieId, getTmdbApiKey(), cancelToken)
        .then((response) {
      try {
        return Result.success(response);
      } catch (e) {
        return Result.failure(e.toFailureReason());
      }
    });
  }
}