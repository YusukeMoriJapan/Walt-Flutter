import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:walt/models/entity/combined_entity/movie_details_with_credits.dart';
import 'package:walt/repository/movie_repository.dart';
import 'package:walt/ui/pages/movie_detail/parts/app_bar/movie_detail_app_bar.dart';
import 'package:walt/ui/pages/movie_detail/parts/app_bar/movie_detail_app_bar_flex_space.dart';
import 'package:walt/ui/pages/movie_detail/parts/horizontal_credits_list.dart';
import 'package:walt/ui/pages/movie_detail/parts/movie_detail_page_content.dart';
import 'package:walt/ui/pages/movie_detail/parts/sliver_movie_detail_list.dart';
import 'package:walt/utils/network/async_snapshot.dart';
import 'package:walt/utils/ui/hard_spring_page_view_scroll_physics.dart';

import '../../../providers/tmdb_config_provider.dart';
import '../../../utils/network/result.dart';
import '../../../utils/ui/icons.dart';
import 'movie_detail_view_model.dart';

class MovieDetailPage extends HookConsumerWidget {
  const MovieDetailPage(this.moviesStateKey, {Key? key}) : super(key: key);

  final String moviesStateKey;
  final maxAppBarHeight = 350.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang =
        ianaCodeToLanguage(Localizations.localeOf(context).languageCode);

    final movieDetailViewModel = ref.watch(movieDetailViewModelProvider(lang));

    final pageController = useRef(PreloadPageController(
            initialPage: movieDetailViewModel
                    .getMoviesStateFromKey(moviesStateKey)
                    ?.currentIndex ??
                0))
        .value;

    final currentMovies = useRef(movieDetailViewModel
            .getMoviesStateFromKey(moviesStateKey)
            ?.currentMovieList)
        .value;

    return PreloadPageView.builder(
        itemCount: currentMovies?.length ?? 1,
        controller: pageController,
        physics: const HardSpringPageViewScrollPhysics(),
        preloadPagesCount: 3,
        onPageChanged: (index) => movieDetailViewModel
            .setMoviesStateCurrentIndex(moviesStateKey, index),
        itemBuilder: (context, index) {
          return HookConsumer(builder: (
            BuildContext context,
            WidgetRef ref,
            Widget? child,
          ) {
            final state = useRef(MovieDetailPageState()).value;
            final id = currentMovies?[index].id?.toInt();

            if (id == null) {
              return TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("映画が存在しません"));
            }

            final lang = ianaCodeToLanguage(
                Localizations.localeOf(context).languageCode);

            final movieDetailViewModel =
                ref.watch(movieDetailViewModelProvider(lang));

            final AsyncSnapshot<Result<MovieDetailsWithCredits>> movieSnapshot =
                useFuture(
                    useRef(movieDetailViewModel.getMovieDetailsWithCredits(id))
                        .value);

            if (movieSnapshot.isFetchingData) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                        icon: const ShadowIcon(
                          Icons.close,
                          color: Colors.black,
                          backgroundColor: Color.fromARGB(76, 255, 255, 255),
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
                body: const Center(
                    child: SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.black54,
                        ))),
              );
            } else {
              return movieSnapshot.buildWidget(
                  onSuccess: (movieDetailsWithCredits) {
                final movieDetails = movieDetailsWithCredits.movieDetails;
                return MovieDetailPageContent(
                    videoDetailAppBar: VideoDetailAppBar(
                        VideoDetailAppBarFlexSpace(
                            appBarHeight: state.appBarHeight,
                            maxAppBarHeight: maxAppBarHeight + 20,
                            onAppBarHeightChanged: (heightValue) {
                              state.updateAppBarHeight(heightValue);
                            },
                            posterPath: movieDetails.posterPath,
                            backDropPath: movieDetails.backdropPath,
                            title: movieDetails.title,
                            baseBackdropImageUrl:
                                ref.watch(backdropImagePathProvider(780)),
                            basePosterImageUrl:
                                ref.watch(posterImagePathProvider(500)),
                            flexibleSpaceBerKey: GlobalKey())),
                    sliverMovieDetailList: SliverMovieDetailList(
                        movieDetailsWithCredits.movieDetails.overview,
                        movieDetailsWithCredits.movieDetails.id,
                        _buildHorizontalCreditList(movieDetailsWithCredits)));
              }, onError: (e) {
                ///TODO FIX エラーハンドリング必要
                return const Center(
                    child: Text(
                  "読み込めませんでした。",
                  style: TextStyle(fontSize: 16),
                ));
              });
            }
          });
        });
  }

  Widget _buildHorizontalCreditList(
      MovieDetailsWithCredits movieDetailsWithCredits) {
    final credits = movieDetailsWithCredits.credits;

    if (credits != null) {
      return SizedBox(
        height: 220,
        child: HorizontalCreditsList(credits, (id) {}),
      );
    } else {
      ///TODO FIX エラーハンドリング
      return const Text("読み込みに失敗しました");
    }
  }
}

class MovieDetailPageArguments {
  final String moviesStateKey;

  const MovieDetailPageArguments({
    required this.moviesStateKey,
  });
}

class MovieDetailPageState {
  final appBarHeight = ValueNotifier<double?>(null);

  updateAppBarHeight(double? height) {
    appBarHeight.value = height;
  }
}
