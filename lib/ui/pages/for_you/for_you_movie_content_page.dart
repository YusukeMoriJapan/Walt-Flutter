import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:walt/utils/network/async_snapshot.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../utils/network/paging/paging_result.dart';

class ForYouMovieContentPage extends HookConsumerWidget {
  final Stream<PagingResult<Movie>> moviesStream;

  final Widget Function(int index, Movie movie) buildMovieImage;
  final Widget Function() buildPageIndicator;
  final Widget Function() buildMovieTitle;
  final Widget Function() buildVoteAverageGauge;
  final ForYouMovieContentPageState state;

  final _topToBottomGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xCB000000),
        Color(0x80000000),
        Color(0x0a000000),
        Color(0x00000000),
        Color(0x0a000000),
        Color(0x80000000),
        Color(0xCC000000),
      ]);

  const ForYouMovieContentPage(
      {required this.state,
      required this.moviesStream,
      required this.buildMovieImage,
      required this.buildMovieTitle,
      required this.buildPageIndicator,
      required this.buildVoteAverageGauge,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useStream(useRef(moviesStream).value);
    final data = snapshot.data;
    final error = snapshot.error;

    if (snapshot.isFetchingData) {
      return const Center(
          child: SizedBox(
        width: 200,
        child: LinearProgressIndicator(
          backgroundColor: Colors.grey,
          color: Colors.black54,
        ),
      ));
    }

    if (error != null) {
      //TODO FIX エラーハンドリング 再読み込み処理を追加
      return TextButton(onPressed: () {}, child: const Text("もう一度読み込む"));
    }

    if (data != null) {
      return data.when(success: (allMovies) {
        final rangedMovies = state.setMovieList(allMovies);
        return Stack(
          children: [
            Container(
              foregroundDecoration:
                  BoxDecoration(gradient: _topToBottomGradient),
              child: PreloadPageView.builder(
                  controller: state.controller,
                  preloadPagesCount: 3,
                  itemCount: rangedMovies.length,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (i) {
                    state.changePagerIndicatorActiveIndex(i);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: buildMovieImage(index, rangedMovies[index]));
                  }),
            ),

            /// 映画ポスターの上に表示するWidget群
            SafeArea(
              child: Stack(
                children: [
                  /// Pager Indicator
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 40),
                    child: buildPageIndicator(),
                  ),

                  /// VoteAverage
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 8, 16),
                      child: buildVoteAverageGauge(),
                    ),
                  ),

                  /// 映画タイトル
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 48, 8, 8),
                    alignment: Alignment.topCenter,
                    child: buildMovieTitle(),
                  )
                ],
              ),
            ),
          ],
        );
      }, failure: (reason, oldList) {
        //TODO FIX エラーハンドリング 再読み込み処理を追加
        return TextButton(onPressed: () {}, child: const Text("もう一度読み込む"));
      });
    }

    //TODO FIX エラーハンドリング 再読み込み処理を追加
    return TextButton(onPressed: () {}, child: const Text("もう一度読み込む"));
  }
}

class ForYouMovieContentPageState {
  final pagerIndicatorActiveIndex = ValueNotifier(0);
  final rangedMoviesLastIndex = 4;
  final controller = PreloadPageController();

  List<Movie>? _rangedMovies;

  late final selectedMovie = ValueNotifier<Movie?>(null);

  List<Movie> setMovieList(List<Movie> allMovies) {
    final rangedMovies =
        allMovies.getRange(0, rangedMoviesLastIndex + 1).toList();
    selectedMovie.value = rangedMovies[pagerIndicatorActiveIndex.value];
    _rangedMovies = rangedMovies;
    return rangedMovies;
  }

  List<Movie>? getMovieList() => _rangedMovies;

  changePagerIndicatorActiveIndex(int index) {
    pagerIndicatorActiveIndex.value = index;

    final rangedMovies = _rangedMovies;
    if (rangedMovies != null) selectedMovie.value = rangedMovies[index];
  }

  ForYouMovieContentPageState();
}
