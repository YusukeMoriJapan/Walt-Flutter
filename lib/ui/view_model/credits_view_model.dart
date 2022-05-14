import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/entity/people/credits.dart';
import '../../repository/movie_repository.dart';
import '../../use_cases/get_movie_credits_use_case.dart';
import '../../utils/network/result.dart';

//TODO FIX onDisposeでStreamの購読解除を行う
final creditsViewModelProvider = Provider.autoDispose
    .family<CreditsViewModel, Language>(
        (ref, param) => CreditsViewModel(ref.read, param));

class CreditsViewModel {
  final Reader _read;
  final Language lang;

  CreditsViewModel(this._read, this.lang);

  Future<Result<Credits>> getMovieCredits(int movieId) =>
      _read(getMovieCreditsUseCase)(
          language: lang,
          movieId: movieId,
          cancelToken: CancelToken(),
          apiVersion: 3);
}
