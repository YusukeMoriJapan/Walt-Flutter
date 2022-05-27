import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:walt/constants/movie_constant.dart';
import 'package:walt/models/entity/movie/movie.dart';
import 'package:walt/ui/pages/for_you/for_you_movie_content_page.dart';
import 'package:walt/ui/pages/for_you/for_you_view_model.dart';
import 'package:walt/ui/pages/for_you/parts/for_you_movie_image.dart';
import 'package:walt/ui/pages/for_you/parts/for_you_movie_title.dart';
import 'package:walt/ui/pages/for_you/parts/for_you_pager_indocator.dart';
import 'package:walt/ui/pages/for_you/parts/vote_average_gauge.dart';
import 'package:walt/utils/hooks/system_hooks.dart';
import 'package:walt/utils/network/paging/paging_result.dart';

import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';
import '../../../utils/ui/hard_spring_page_view_scroll_physics.dart';
import '../movie_detail/movie_detail_page.dart';
import 'parts/colored_tab_bar.dart';

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
  final stateList = List.generate(3, (index) => ForYouMovieContentPageState());

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
                  return _buildForYouMovieContentPage(
                      forYouViewModel.trendingMovies.movieListStream,
                      trendingMovieListKey,
                      forYouViewModel,
                      stateList[0]);

                case 1:
                  return _buildForYouMovieContentPage(
                      forYouViewModel.popularMovies.movieListStream,
                      popularMovieListKey,
                      forYouViewModel,
                      stateList[1]);

                case 2:
                  return _buildForYouMovieContentPage(
                      forYouViewModel.topRatedMovies.movieListStream,
                      topRatedMovieListKey,
                      forYouViewModel,
                      stateList[2]);
                default:

                  ///TODO FIX エラーハンドリング必須
                  return const Text("error");
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

  Widget _buildForYouMovieContentPage(
    Stream<PagingResult<Movie>> moviesStream,
    String moviesStateKey,
    ForYouViewModel forYouViewModel,
    ForYouMovieContentPageState state,
  ) {
    return Builder(builder: (context) {
      return ForYouMovieContentPage(
          state: state,
          moviesStream: moviesStream,
          buildMovieImage: (index, movie) {
            return ForYouMovieImage(
                index: index,
                onTapImage: (i) {
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

                    if (index != null && index <= state.rangedMoviesLastIndex) {
                      state.controller.jumpToPage(index);
                      state.pagerIndicatorActiveIndex.value = index;
                    }
                  });
                },
                posterPath: movie.posterPath ?? "");
          },
          buildMovieTitle: () => ForYouMovieTitle(state.selectedMovie),
          buildPageIndicator: () {
            final movieListLength = state.getMovieList()?.length;
            if (movieListLength != null) {
              return ForYouPagerIndicator(
                  state.pagerIndicatorActiveIndex, movieListLength);
            } else {
              return const SizedBox(
                width: 0,
                height: 0,
              );
            }
          },
          buildVoteAverageGauge: () => VoteAverageGauge(state.selectedMovie));
    });
  }
}
