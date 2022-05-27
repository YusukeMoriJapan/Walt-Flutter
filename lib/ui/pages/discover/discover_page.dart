import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:walt/constants/movie_constant.dart';
import 'package:walt/providers/tmdb_config_provider.dart';
import 'package:walt/ui/pages/discover/discover_view_model.dart';
import 'package:walt/ui/pages/discover/ui_model/row_content.dart';
import 'package:walt/ui/pages/movie_detail/movie_detail_page.dart';
import 'package:walt/ui/states/event_store.dart';

import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';

class DiscoverPage extends HookConsumerWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang =
        ianaCodeToLanguage(Localizations.localeOf(context).languageCode);

    final region =
        ianaCodeToRegion(Localizations.localeOf(context).countryCode);

    final discoverViewModel = ref.watch(discoverViewModelProvider(
        DiscoverViewModelParam(language: lang, region: region)));

    final eventStore = ref.watch(eventStoreProvider);

    useEffect(() {
      discoverViewModel.registerCustomDiscoveredMovieList(
          animePopularMovieListKey, "16", "popularity.desc");
      discoverViewModel.registerCustomDiscoveredMovieList(
          romancePopularMovieListKey, "10749", "popularity.desc");
      discoverViewModel.registerCustomDiscoveredMovieList(
          thrillerPopularMovieListKey, "53", "popularity.desc");
      discoverViewModel.registerCustomDiscoveredMovieList(
          sfPopularMovieListKey, "878", "popularity.desc");
      return null;
    }, [true]);

    final allRowContents = useRef<List<DiscoverRowContentUiModel>>([
      DiscoverRowContentUiModel(
          headerName: "Trending",
          key: const PageStorageKey(trendingMovieListKey),
          listKey: const ValueKey(trendingMovieListKey),
          moviesState: discoverViewModel.trendingMovies,
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context, id, discoverViewModel, trendingMovieListKey, controller),
          onNextPageRequested: () =>
              discoverViewModel.requestNextPageMovies(trendingMovieListKey),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Up Coming",
          key: const PageStorageKey(upComingMovieListKey),
          listKey: const ValueKey(upComingMovieListKey),
          moviesState: discoverViewModel.upComingMovies,
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context, id, discoverViewModel, upComingMovieListKey, controller),
          onNextPageRequested: () =>
              discoverViewModel.requestNextPageMovies(upComingMovieListKey),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Popular",
          key: const PageStorageKey(popularMovieListKey),
          listKey: const ValueKey(popularMovieListKey),
          moviesState: discoverViewModel.popularMovies,
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context, id, discoverViewModel, popularMovieListKey, controller),
          onNextPageRequested: () =>
              discoverViewModel.requestNextPageMovies(popularMovieListKey),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "TopRated",
          key: const PageStorageKey(topRatedMovieListKey),
          listKey: const ValueKey(topRatedMovieListKey),
          moviesState: discoverViewModel.topRatedMovies,
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context, id, discoverViewModel, topRatedMovieListKey, controller),
          onNextPageRequested: () =>
              discoverViewModel.requestNextPageMovies(topRatedMovieListKey),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Anime",
          key: const PageStorageKey(animePopularMovieListKey),
          listKey: const ValueKey(animePopularMovieListKey),
          moviesState:
              discoverViewModel.getMoviesStateFromKey(animePopularMovieListKey),
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context,
              id,
              discoverViewModel,
              animePopularMovieListKey,
              controller),
          onNextPageRequested: () =>
              discoverViewModel.requestNextPageMovies(animePopularMovieListKey),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Romance",
          key: const PageStorageKey(romancePopularMovieListKey),
          listKey: const ValueKey(romancePopularMovieListKey),
          moviesState: discoverViewModel
              .getMoviesStateFromKey(romancePopularMovieListKey),
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context,
              id,
              discoverViewModel,
              romancePopularMovieListKey,
              controller),
          onNextPageRequested: () => discoverViewModel
              .requestNextPageMovies(romancePopularMovieListKey),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Thriller",
          key: const PageStorageKey(thrillerPopularMovieListKey),
          listKey: const ValueKey(thrillerPopularMovieListKey),
          moviesState: discoverViewModel
              .getMoviesStateFromKey(thrillerPopularMovieListKey),
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context,
              id,
              discoverViewModel,
              thrillerPopularMovieListKey,
              controller),
          onNextPageRequested: () => discoverViewModel
              .requestNextPageMovies(thrillerPopularMovieListKey),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Science Fiction",
          key: const PageStorageKey(sfPopularMovieListKey),
          listKey: const ValueKey(sfPopularMovieListKey),
          moviesState:
              discoverViewModel.getMoviesStateFromKey(sfPopularMovieListKey),
          onClickMovieImage: (id, controller) => _navigateToMovieDetailPage(
              context,
              id,
              discoverViewModel,
              sfPopularMovieListKey,
              controller),
          onNextPageRequested: () =>
              discoverViewModel.requestNextPageMovies(sfPopularMovieListKey),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
    ]).value;

    return PageStorage(
        bucket: PageStorageBucket(),
        child: RefreshIndicator(
          onRefresh: () async {
            eventStore.isRefreshInvoked = true;
            for (var element in allRowContents) {
              element.scrollController.jumpTo(0);
              element.moviesState?.refreshMovieList();
            }
          },
          child: ListView.builder(
              itemCount: allRowContents.length,
              itemBuilder: (context, i) {
                return allRowContents[i].buildRowContent();
              }),
        ));
  }

  _navigateToMovieDetailPage(
      BuildContext context,
      int index,
      DiscoverViewModel discoverViewModel,
      String key,
      AutoScrollController controller) {
    discoverViewModel.setMoviesStateCurrentIndex(key, index);
    Navigator.of(context)
        .pushNamed("/movieDetail",
            arguments: MovieDetailPageArguments(moviesStateKey: key))
        .then((_) {
      final currentIndex =
          discoverViewModel.getMoviesStateFromKey(key)?.currentIndex;
      if (currentIndex != null) {
        controller.scrollToIndex(currentIndex,
            preferPosition: AutoScrollPosition.middle);
      }
    });
  }
}
