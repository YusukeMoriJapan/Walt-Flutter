import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:walt/ui/pages/for_you/for_you_view_model.dart';
import 'package:walt/ui/pages/for_you/parts/for_you_movie_image.dart';
import 'package:walt/ui/pages/for_you/parts/for_you_movie_title.dart';
import 'package:walt/ui/pages/for_you/parts/for_you_pager_indocator.dart';
import 'package:walt/ui/pages/for_you/parts/vote_average_gauge.dart';
import 'package:walt/utils/network/async_snapshot.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../utils/network/paging/paging_result.dart';
import '../movie_detail/movie_detail_page.dart';

class ForYouMovieContentPage extends HookConsumerWidget {
  final Stream<PagingResult<Movie>> moviesStream;
  final controller = PreloadPageController();
  final String moviesStateKey;
  final ForYouViewModel forYouViewModel;

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

  ForYouMovieContentPage(
      this.moviesStream, this.moviesStateKey, this.forYouViewModel,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagerIndicatorActiveIndex = useState(0);

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
        const rangedMoviesLastIndex = 4;
        final rangedMovies =
            useRef(allMovies.getRange(0, rangedMoviesLastIndex + 1).toList())
                .value;

        final selectedMovie =
            useValueNotifier(rangedMovies[pagerIndicatorActiveIndex.value]);

        useEffect(() {
          selectedMovie.value = rangedMovies[pagerIndicatorActiveIndex.value];
          return null;
        }, [pagerIndicatorActiveIndex.value]);

        return Stack(
          children: [
            Container(
              foregroundDecoration:
                  BoxDecoration(gradient: _topToBottomGradient),
              child: PreloadPageView.builder(
                  controller: controller,
                  preloadPagesCount: 3,
                  itemCount: rangedMovies.length,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (i) {
                    pagerIndicatorActiveIndex.value = i;
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final posterPath = rangedMovies[index].posterPath ?? "";
                    return Center(
                        child: ForYouMovieImage(
                            index: index,
                            onTapImage: (index) => _onMovieImageTap(
                                index,
                                rangedMoviesLastIndex,
                                pagerIndicatorActiveIndex,
                                context),
                            posterPath: posterPath));
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
                    child: ForYouPagerIndicator(
                        pagerIndicatorActiveIndex, rangedMovies.length),
                  ),

                  /// VoteAverage
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 8, 16),
                      child: VoteAverageGauge(selectedMovie),
                    ),
                  ),

                  /// 映画タイトル
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 48, 8, 8),
                    alignment: Alignment.topCenter,
                    child: ForYouMovieTitle(selectedMovie),
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

  _onMovieImageTap(int index, int rangedMoviesLastIndex,
      ValueNotifier pagerIndicatorActiveIndex, BuildContext context) {
    forYouViewModel.getMoviesStateFromKey(moviesStateKey)?.currentIndex = index;
    Navigator.of(context)
        .pushNamed("/movieDetail",
            arguments: MovieDetailPageArguments(moviesStateKey: moviesStateKey))
        .then((_) {
      final index =
          forYouViewModel.getMoviesStateFromKey(moviesStateKey)?.currentIndex;

      if (index != null && index <= rangedMoviesLastIndex) {
        controller.jumpToPage(index);
        pagerIndicatorActiveIndex.value = index;
      }
    });
  }
}
