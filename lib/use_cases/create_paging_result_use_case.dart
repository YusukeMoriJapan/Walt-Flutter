import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/utils/network/paging/paging_result.dart';

import '../models/entity/movie/movie.dart';
import '../utils/network/result.dart';

final createPagingResultUseCase = Provider((ref) {
  return (
      {required Result<List<Movie>> result,
      required List<Movie>? oldMovieList}) {
    return result.when(success: (newMovieList) {
      if (oldMovieList != null) {
        return PagingSuccess([...oldMovieList, ...newMovieList]);
      } else {
        return PagingSuccess(newMovieList);
      }
    }, failure: (e) {
      return PagingFailure(e, oldMovieList);
    });
  };
});
