import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';

import '../../models/entity/people/credits.dart';
import '../../use_cases/get_movie_credits_use_case.dart';
import '../../utils/network/result.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final creditsViewModelProvider =
    Provider.autoDispose((ref) => CreditsViewModel(ref.read));

class CreditsViewModel {
  final Reader _read;

  CreditsViewModel(this._read);

  Future<Result<Credits>> getMovieCredits(int movieId) =>
      _read(getMovieCreditsUseCase)(
          language: Language.japanese,
          movieId: movieId,
          cancelToken: CancelToken(),
          apiVersion: 3);
}
