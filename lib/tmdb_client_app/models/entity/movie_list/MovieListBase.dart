import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:walt/tmdb_client_app/models/entity/movie.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_list_page.dart';

import '../../../repository/movie_repository.dart';
import '../../../use_cases/get_movies_use_case.dart';
import '../../../utils/network/paging/paging_result.dart';
import '../../../utils/network/result.dart';
import '../../region/region.dart';

class MovieList {
  final Future<PagingResult<Movie>> Function() _getMovieList;

  /// streamの現在値を同期的に取得できないため、別変数で管理
  ///(stream.lastで現在値を取得しようとすると、StateError("Stream has already been listened to.")エラーが発生する)
  int currentPage = 1;

  bool get currentMovieListIsNull => currentMovieList?.isEmpty ?? true;

  bool _newMovieListIsRequested = false;

  /// useStreamで初期値を与える時は、必ずuseStreamを実行した後にcontroller.addを実行すること
  final _pagingController = BehaviorSubject<PagingResult<Movie>>();
  List<Movie>? currentMovieList;
  late final Stream<PagingResult<Movie>> movieListStream;

  MovieList(this._getMovieList) {
    movieListStream = _pagingController.stream;
  }

  _requestMovieList() async {
    _newMovieListIsRequested = true;
    _getMovieList()
        .whenComplete(() => {_newMovieListIsRequested = false})
        .then((value) {
      _pagingController.value = value;
      currentMovieList = value.when(
          success: (data) => data,
          failure: (reason, oldList) {
            currentPage--;
            return oldList;
          });
    });
  }

  refreshMovieList() {
    currentPage = 1;
    currentMovieList = null;
    _requestMovieList();
  }

  requestNextPageMovieList() {
    if (!_newMovieListIsRequested) {
      currentPage++;
      _requestMovieList();
    }
  }
}
