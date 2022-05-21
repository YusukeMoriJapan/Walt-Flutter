import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:walt/constants/movie_constant.dart';
import 'package:walt/ui/pages/for_you/for_you_movie_content_page.dart';
import 'package:walt/ui/pages/for_you/for_you_view_model.dart';
import 'package:walt/utils/hooks/system_hooks.dart';

import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';
import '../../../utils/ui/hard_spring_page_view_scroll_physics.dart';
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
                  return ForYouMovieContentPage(
                      forYouViewModel.trendingMovies.movieListStream,
                      trendingMovieListKey,
                      forYouViewModel);

                case 1:
                  return ForYouMovieContentPage(
                      forYouViewModel.popularMovies.movieListStream,
                      popularMovieListKey,
                      forYouViewModel);

                case 2:
                  return ForYouMovieContentPage(
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
