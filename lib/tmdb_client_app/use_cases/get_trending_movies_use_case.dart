import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';

import '../models/entity/movie.dart';
import '../utils/network/paging/paging_result.dart';
import '../utils/network/result.dart';

final getTrendingMoviesUseCase = Provider((ref) {
  return (
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      required TimeWindow timeWindow,
      required List<Movie>? oldMovieList,
      required CancelToken cancelToken}) {


    return ref
        .read(movieRepository)
        .getTrendingMovies(
            language: language,
            page: page,
            apiVersion: apiVersion,
            region: region,
            timeWindow: timeWindow,
            cancelToken: cancelToken)
        .then<PagingResult<Movie>>((result) {
      return result.when(success: (newMovieList) {
        if (oldMovieList != null) {
          return PagingSuccess([...oldMovieList, ...newMovieList]);
        } else {
          return PagingSuccess(newMovieList);
        }
      }, failure: (e) {
        return PagingFailure(e, oldMovieList);
      });
    });
  };
});


Stream<int> fooo() async*{

}
