import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/credits_repository.dart';

import '../models/entity/people/credits.dart';
import '../utils/network/result.dart';

///TODO FIX CancelTokenを外部から注入できるようにしないといけない
final creditsProvider =
    FutureProvider.family<Result<Credits>, int>((ref, id) async {
  final token = CancelToken();
  ref.onDispose(() => token.cancel());

  return await ref
      .read(creditsRepository)
      .getMovieCredits(apiVersion: 3, movieId: id, cancelToken: token);
});
