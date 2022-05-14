import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:walt/repository/movie_repository.dart';
import 'package:walt/ui/pages/movie_detail/parts/movie_detail_page_content.dart';
import 'package:walt/ui/view_model/movie_view_model.dart';
import 'package:walt/utils/network/async_snapshot.dart';

import '../../../models/entity/movie/movie_detail/movie_details.dart';
import '../../../models/region/region.dart';
import '../../../utils/network/result.dart';
import '../../../utils/ui/icons.dart';
import '../../view_model/credits_view_model.dart';

class MovieDetailPage extends HookConsumerWidget {
  const MovieDetailPage(this.defaultMovieId, this.movieIds, {Key? key})
      : super(key: key);

  final int defaultMovieId;
  final List<int>? movieIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = useRef(PreloadPageController(
            initialPage:
                movieIds?.indexWhere((element) => element == defaultMovieId) ??
                    0))
        .value;

    return PreloadPageView.builder(
        itemCount: movieIds?.length ?? 1,
        controller: pageController,
        preloadPagesCount: 3,
        itemBuilder: (context, index) {
          return HookConsumer(builder: (
            BuildContext context,
            WidgetRef ref,
            Widget? child,
          ) {
            final _id = _getId(index);

            final lang = ianaCodeToLanguage(
                Localizations.localeOf(context).languageCode);

            final region =
                ianaCodeToRegion(Localizations.localeOf(context).countryCode);

            final movieViewModel = ref.watch(movieViewModelProvider(
                MovieViewModelParam(language: lang, region: region)));

            final creditsViewModel = ref.watch(creditsViewModelProvider(lang));

            final AsyncSnapshot<Result<MovieDetails>> movieSnapshot =
                useFuture(useRef(movieViewModel.getMovieDetails(_id)).value);

            final creditsSnapshot =
                useRef(creditsViewModel.getMovieCredits(_id)).value;

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
              return movieSnapshot.buildWidget(onSuccess: (movie) {
                return MovieDetailPageContent(
                  movieDetails: movie,
                  creditsFuture: creditsSnapshot,
                );
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

  int _getId(int index) {
    final _movieIds = movieIds;
    if (_movieIds == null) {
      return defaultMovieId;
    } else {
      return _movieIds[index];
    }
  }
}

class MovieDetailPageArguments {
  final int defaultMovieId;
  final List<int>? movieIds;

  const MovieDetailPageArguments(this.defaultMovieId, [this.movieIds]);
}
