import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:walt/models/entity/movie/movie.dart';

import '../../utils/network/paging/paging_result.dart';

typedef GetMovieList = Future<PagingResult<Movie>> Function(
    int page, List<Movie>? oldMovieList);

final movieStateProvider = Provider.autoDispose
    .family<MoviesState, MoviesStateParam>((ref, param) =>
        MoviesState(param.getMovieList, param.key)..refreshMovieList());

final customMovieStateMapProvider =
    Provider.autoDispose<Map<String, MoviesState>>((ref) => {});

class MoviesState {
  final GetMovieList? _getMovieList;
  final String key;

  /// streamの現在値を同期的に取得できないため、別変数で管理
  ///(stream.lastで現在値を取得しようとすると、StateError("Stream has already been listened to.")エラーが発生する)
  int currentPage = 1;
  int currentIndex = 0;

  bool get currentMovieListIsNull => currentMovieList?.isEmpty ?? true;

  bool _newMovieListIsRequested = false;

  /// useStreamで初期値を与える時は、必ずuseStreamを実行した後にcontroller.addを実行すること
  final _pagingController = BehaviorSubject<PagingResult<Movie>>();
  List<Movie>? currentMovieList;
  late final Stream<PagingResult<Movie>> movieListStream;

  MoviesState(this._getMovieList, this.key) {
    movieListStream = _pagingController.stream;
  }

  _requestMovieList() async {
    //TODO FIX _getMovieListがnull時のハンドリングが必要
    _newMovieListIsRequested = true;
    _getMovieList
        ?.call(currentPage, currentMovieList)
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

class MoviesStateParam {
  final String key;
  final GetMovieList? getMovieList;

  const MoviesStateParam(this.key, [this.getMovieList]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoviesStateParam &&
          runtimeType == other.runtimeType &&
          key == other.key);

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() {
    return 'MoviesStateParam{ key: $key, getMovieList: $getMovieList,}';
  }
}
