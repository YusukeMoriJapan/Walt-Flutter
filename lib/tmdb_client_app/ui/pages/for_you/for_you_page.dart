import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walt/tmdb_client_app/models/mock/mock_movie.dart';
import 'package:walt/tmdb_client_app/models/region/region.dart';
import 'package:walt/tmdb_client_app/ui/view_model/movie_view_model.dart';
import 'package:walt/tmdb_client_app/ui/view_model/watch_provider_view_model.dart';
import 'package:walt/tmdb_client_app/use_cases/get_watch_provider_use_case.dart';
import 'package:walt/tmdb_client_app/utils/hooks/system_hooks.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../models/entity/movie.dart';
import '../../../models/entity/watch_provider/provider_metadata.dart';
import '../../../utils/ui/hard_spring_page_view_scroll_physics.dart';

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
    return Stack(
      children: [
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
                  return MovieContentPage(ref.read(mock007MoviesProvider));

                case 1:
                  return MovieContentPage(ref.read(mockJohnWickMoviesProvider));

                case 2:
                  return MovieContentPage(
                      ref.read(mockFastAndFuriousMoviesProvider));
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
                tabs: [
                  Tab(text: 'Trending'),
                  Tab(text: 'Popular'),
                  Tab(text: 'High Rated'),
                ],
                onTap: (i) {
                controllerParent.animateToPage(i, duration: Duration(milliseconds:250), curve: Curves.ease);
                },
              )),
        ),
        // Container(
        //   alignment: Alignment.topCenter,
        //   padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        //   child: Text("Trending      Popular      High Rated",
        //       // textAlign: TextAlign.center,
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w300,
        //         color: Theme.of(context).primaryColor,
        //       )),
        // ),
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
  final List<Movie> movies;
  final controller = PreloadPageController();

  MovieContentPage(this.movies, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagerIndicatorActiveIndex = useState(0);
    final selectedMovie = movies[pagerIndicatorActiveIndex.value];

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
              itemCount: movies.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (i) {
                pagerIndicatorActiveIndex.value = i;
              },
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      final movieId = selectedMovie.id;
                      if (movieId != null) {
                        _showWatchProviderBottomSheet(context, ref, movieId);
                      } else {
                        ///TODO FIX スナックバーで読み込めないことを通知する
                      }
                    },
                    child: Image.network(
                      /// nullハンドリング必要
                      movies[index].posterPath ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
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
                child: AnimatedSmoothIndicator(
                    activeIndex: pagerIndicatorActiveIndex.value,
                    effect: SlideEffect(
                        activeDotColor: Theme.of(context).primaryColor,
                        dotWidth: 8,
                        dotHeight: 8,
                        spacing: 16),
                    count: movies.length,
                    axisDirection: Axis.vertical),
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
                        child: CircularProgressIndicator(
                            strokeWidth: 4,
                            backgroundColor:
                                const Color.fromARGB(102, 158, 158, 158),
                            value: selectedMovie.getVoteAverageForIndicator()),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedMovie.getVoteAverageForText().toString(),
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
                    Text(selectedMovie.name ?? "",
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
  }

  _showWatchProviderBottomSheet(
      BuildContext context, WidgetRef ref, num movieId) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

                  /// Opacity適用するため、Stack x BackdropFilterを組み合わせている
                  child: HookConsumer(builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final viewModel = ref.read(watchProviderViewModelProvider);
                    final snapshot = useFuture(useMemoized(() =>
                        viewModel.getMovieWatchProvider(movieId.toInt())));

                    ///TODO FIX エラーハンドリング専用の拡張関数を追加する
                    final data = snapshot.data;
                    if (data != null) {
                      return data.when(
                          success: (providers) =>
                              WatchProviderDetail(providers),

                          ///TODO FIX エラーハンドリング
                          failure: (e) => Text(e.toString()));
                    } else {
                      ///TODO FIX 読み込み中インジケータ表示する
                      return const Text("読み込み中");
                    }
                  }),
                ),
              ],
            ),
          );
        });
  }
}

class WatchProviderDetail extends HookConsumerWidget {
  const WatchProviderDetail(this.providerMetadataList, {Key? key})
      : super(key: key);

  final ProviderMetadataList providerMetadataList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// flatrate
    final Iterable<Widget>? flatrateLogoList =
        providerMetadataList.flatrate?.map((provider) {
      final logo = provider.logoPath;
      if (logo != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              final tmdbLink = providerMetadataList.link;
              if (tmdbLink != null) {
                launch(tmdbLink);
              } else {
                ///TODO FIX エラーハンドリング snackbar表示する
              }
            },
            child: Image.network(
              "https://www.themoviedb.org/t/p/original/" + logo,
              width: 50,
              height: 50,
            ),
          ),
        );
      } else {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
    });

    /// buy
    final Iterable<Widget>? buyLogoList =
        providerMetadataList.buy?.map((provider) {
      final logo = provider.logoPath;
      if (logo != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              final tmdbLink = providerMetadataList.link;
              if (tmdbLink != null) {
                launch(tmdbLink);
              } else {
                ///TODO FIX エラーハンドリング snackbar表示する
              }
            },
            child: Image.network(
              "https://www.themoviedb.org/t/p/original/" + logo,
              width: 50,
              height: 50,
            ),
          ),
        );
      } else {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
    });

    /// rent
    final Iterable<Widget>? rentLogoList =
        providerMetadataList.rent?.map((provider) {
      final logo = provider.logoPath;
      if (logo != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              final tmdbLink = providerMetadataList.link;
              if (tmdbLink != null) {
                launch(tmdbLink);
              } else {
                ///TODO FIX エラーハンドリング snackbar表示する
              }
            },
            child: Image.network(
              "https://www.themoviedb.org/t/p/original/" + logo,
              width: 50,
              height: 50,
            ),
          ),
        );
      } else {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
    });

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Watch Now",
            style: const TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Text(
              "Flatrate",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Align(
            child: Wrap(
              children: [
                ...?flatrateLogoList,
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Text(
              "Buy",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Wrap(
            children: [
              ...?buyLogoList,
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Text(
              "Rent",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Wrap(
            children: [
              ...?rentLogoList,
            ],
          ),
        ],
      ),
    );
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

// return Center(
//     child: Stack(
//   children: [
//     Image.network(
//       "https://www.themoviedb.org/t/p/original/2kExe7ImkVP4emxWGoJnraxthWd.jpg",
//       fit: BoxFit.cover,
//       width: double.infinity,
//       height: double.infinity,
//     ),
//     SafeArea(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text("Trending",
//             style: TextStyle(
//                 fontSize: 40,
//                 fontWeight: FontWeight.w300,
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 shadows: const <Shadow>[
//                   Shadow(
//                     offset: Offset(2.0, 2.0),
//                     blurRadius: 10.0,
//                     color: Colors.black87,
//                   ),
//                 ])),
//         Text("Casino Royale",
//             style: TextStyle(
//                 fontSize: 40,
//                 fontWeight: FontWeight.w300,
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 shadows: const <Shadow>[
//                   Shadow(
//                     offset: Offset(2.0, 2.0),
//                     blurRadius: 10.0,
//                     color: Colors.black87,
//                   ),
//                 ])),
//       ],
//     ))
//   ],
// ));
