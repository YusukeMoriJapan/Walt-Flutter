import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walt/constants/movie_constant.dart';
import 'package:walt/ui/pages/for_you/for_you_view_model.dart';
import 'package:walt/utils/hooks/system_hooks.dart';
import 'package:walt/utils/network/async_snapshot.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../models/region/region.dart';
import '../../../providers/tmdb_config_provider.dart';
import '../../../repository/movie_repository.dart';
import '../../../utils/network/paging/paging_result.dart';
import '../../../utils/ui/hard_spring_page_view_scroll_physics.dart';
import '../movie_detail/movie_detail_page.dart';

class ForYouPage extends HookConsumerWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useFullScreenUntilDispose([true]);

    return const Center(
      child: ForYouPagerContent(),
    );
  }
}

class ForYouPagerContent extends StatefulHookConsumerWidget {
  const ForYouPagerContent({Key? key}) : super(key: key);

  @override
  createState() {
    return ForYouPagerContentState();
  }
}

class ForYouPagerContentState extends ConsumerState<ConsumerStatefulWidget>
    with TickerProviderStateMixin {
  final controllerParent = PreloadPageController();

  @override
  Widget build(BuildContext context) {
    final tabController = useRef(TabController(length: 3, vsync: this));
    final lang =
        ianaCodeToLanguage(Localizations.localeOf(context).languageCode);

    final region =
        ianaCodeToRegion(Localizations.localeOf(context).countryCode);

    final forYouViewModel = ref.watch(forYouViewModelProvider(
        ForYouViewModelParam(language: lang, region: region)));

    return Stack(
      children: [
        Container(color: Colors.black),
        PreloadPageView.builder(
            physics: const HardSpringPageViewScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            controller: controllerParent,
            preloadPagesCount: 3,
            onPageChanged: (i) {
              tabController.value.index = i;
            },
            itemBuilder: (BuildContext context, int indexParent) {
              switch (indexParent) {
                case 0:
                  return MovieContentPage(
                      forYouViewModel.trendingMovies.movieListStream,
                      trendingMovieListKey,
                      forYouViewModel);

                case 1:
                  return MovieContentPage(
                      forYouViewModel.popularMovies.movieListStream,
                      popularMovieListKey,
                      forYouViewModel);

                case 2:
                  return MovieContentPage(
                      forYouViewModel.topRatedMovies.movieListStream,
                      topRatedMovieListKey,
                      forYouViewModel);
                default:

                  ///TODO FIX エラーハンドリング必須
                  return const Text("何か投げる");
              }
            }),

        /// Tabインジケータ
        SafeArea(
          child: ColoredTabBar(
              Colors.transparent,
              TabBar(
                controller: tabController.value,
                tabs: const [
                  Tab(text: 'Trending'),
                  Tab(text: 'Popular'),
                  Tab(text: 'Top Rated'),
                ],
                onTap: (i) {
                  controllerParent.animateToPage(i,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.ease);
                },
              )),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.arrow_back_ios, color: Colors.white60)),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.arrow_forward_ios, color: Colors.white60)),
      ],
    );
  }
}

class MovieContentPage extends HookConsumerWidget {
  final Stream<PagingResult<Movie>> moviesStream;
  final controller = PreloadPageController();
  final String moviesStateKey;
  final ForYouViewModel forYouViewModel;

  MovieContentPage(this.moviesStream, this.moviesStateKey, this.forYouViewModel,
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
            allMovies.getRange(0, rangedMoviesLastIndex + 1).toList();
        final selectedMovie = rangedMovies[pagerIndicatorActiveIndex.value];
        return Stack(
          children: [
            Container(
              foregroundDecoration: const BoxDecoration(
                  gradient: LinearGradient(
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
                  ])),
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
                      child: InkWell(
                        onTap: () {
                          forYouViewModel
                              .getMoviesStateFromKey(moviesStateKey)
                              ?.currentIndex = index;
                          Navigator.of(context)
                              .pushNamed("/movieDetail",
                                  arguments: MovieDetailPageArguments(
                                      moviesStateKey: moviesStateKey))
                              .then((_) {
                            final index = forYouViewModel
                                .getMoviesStateFromKey(moviesStateKey)
                                ?.currentIndex;

                            print(index.toString());

                            if (index != null &&
                                index <= rangedMoviesLastIndex) {
                              controller.jumpToPage(index);
                              pagerIndicatorActiveIndex.value = index;
                            }
                          });
                        },
                        child: Image.network(
                          /// nullハンドリング必要
                          ref.watch(posterImagePathProvider(780)) + posterPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              final expectedBytes =
                                  loadingProgress.expectedTotalBytes ?? 0;
                              return SizedBox(
                                width: 200,
                                child: LinearProgressIndicator(
                                    value:
                                        loadingProgress.cumulativeBytesLoaded /
                                            expectedBytes),
                              );
                            }
                          },
                        ),
                      ),
                    );
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
                    child: HookConsumer(builder: (context, ref, child) {
                      return AnimatedSmoothIndicator(
                          activeIndex: pagerIndicatorActiveIndex.value,
                          effect: SlideEffect(
                              activeDotColor: _useActivePagerIndicatorColor(),
                              dotWidth: 8,
                              dotHeight: 8,
                              spacing: 16),
                          count: rangedMovies.length,
                          axisDirection: Axis.vertical);
                    }),
                  ),

                  /// VoteAverage
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 8, 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 72,
                            height: 72,
                            child: HookConsumer(builder: (context, ref, child) {
                              final isDarkMode = useDarkModeState();
                              Color color;
                              if (isDarkMode) {
                                color =
                                    Theme.of(context).colorScheme.secondary;
                              } else {
                                color = Theme.of(context).colorScheme.primary;
                              }

                              return CircularProgressIndicator(
                                  strokeWidth: 4,
                                  backgroundColor:
                                      const Color.fromARGB(102, 158, 158, 158),
                                  color: color,
                                  value: selectedMovie
                                      .getVoteAverageForIndicator());
                            }),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedMovie
                                    .getVoteAverageForText()
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "%",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  /// 映画タイトル
                  /// TODO FIX 何らかのNotifierを使い、画面上部のPagerIndicatorを避けるPaddingを動的に設定するコードに変更する必要あり
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 48, 8, 8),
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Text(selectedMovie.title ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              // fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ))
                      ],
                    ),
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

  Color _useActivePagerIndicatorColor() {
    if (useDarkModeState()) {
      return Theme.of(useContext()).colorScheme.secondary;
    } else {
      return Theme.of(useContext()).colorScheme.primary;
    }
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar, {Key? key}) : super(key: key);

  @override
  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
