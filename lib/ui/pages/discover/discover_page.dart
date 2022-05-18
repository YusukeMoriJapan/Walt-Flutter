import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/providers/tmdb_config_provider.dart';
import 'package:walt/ui/pages/discover/discover_view_model.dart';
import 'package:walt/ui/pages/discover/ui_model/row_content.dart';
import 'package:walt/ui/pages/movie_detail/movie_detail_page.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../models/region/region.dart';
import '../../../repository/movie_repository.dart';

const animeKey = "popularAnime";
const romanceKey = "popularRomance";
const thrillerKey = "popularThriller";
const sfKey = "popularScienceFiction";

class DiscoverPage extends HookConsumerWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang =
        ianaCodeToLanguage(Localizations.localeOf(context).languageCode);

    final region =
        ianaCodeToRegion(Localizations.localeOf(context).countryCode);

    final movieViewModel = ref.watch(discoverViewModelProvider(
        DiscoverViewModelParam(language: lang, region: region)));

    useEffect(() {
      movieViewModel.registerCustomDiscoveredMovieList(
          animeKey, "16", "popularity.desc");
      movieViewModel.registerCustomDiscoveredMovieList(
          romanceKey, "10749", "popularity.desc");
      movieViewModel.registerCustomDiscoveredMovieList(
          thrillerKey, "53", "popularity.desc");
      movieViewModel.registerCustomDiscoveredMovieList(
          sfKey, "878", "popularity.desc");
      return null;
    }, [true]);

    final allRowContents = useRef<List<DiscoverRowContentUiModel>>([
      DiscoverRowContentUiModel(
          headerName: "Trending",
          key: const PageStorageKey("trending"),
          listKey: const ValueKey("trending"),
          moviesState: movieViewModel.trendingMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(
                  movieViewModel.trendingMovieList.currentMovieList)),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Up Coming",
          key: const PageStorageKey("upComing"),
          listKey: const ValueKey("upComing"),
          moviesState: movieViewModel.upComingMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(
                  movieViewModel.upComingMovieList.currentMovieList)),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Popular",
          key: const PageStorageKey("popular"),
          listKey: const ValueKey("popular"),
          moviesState: movieViewModel.popularMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(
                  movieViewModel.popularMovieList.currentMovieList)),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "TopRated",
          key: const PageStorageKey("topRated"),
          listKey: const ValueKey("topRated"),
          moviesState: movieViewModel.topRatedMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(
                  movieViewModel.topRatedMovieList.currentMovieList)),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Anime",
          key: const PageStorageKey(animeKey),
          listKey: const ValueKey(animeKey),
          moviesState: movieViewModel.getCustomMovieList(animeKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(movieViewModel
                  .getCustomMovieList(animeKey)
                  ?.currentMovieList)),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Romance",
          key: const PageStorageKey(romanceKey),
          listKey: const ValueKey(romanceKey),
          moviesState: movieViewModel.getCustomMovieList(romanceKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(movieViewModel
                  .getCustomMovieList(romanceKey)
                  ?.currentMovieList)),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Thriller",
          key: const PageStorageKey(thrillerKey),
          listKey: const ValueKey(thrillerKey),
          moviesState: movieViewModel.getCustomMovieList(thrillerKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(movieViewModel
                  .getCustomMovieList(thrillerKey)
                  ?.currentMovieList)),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Science Fiction",
          key: const PageStorageKey(sfKey),
          listKey: const ValueKey(sfKey),
          moviesState: movieViewModel.getCustomMovieList(sfKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(
              context,
              id,
              _convertToMovieIdList(
                  movieViewModel.getCustomMovieList(sfKey)?.currentMovieList)),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.watch(backdropImagePathProvider(780)),
          posterImageUrl: ref.watch(posterImagePathProvider(342))),
    ]).value;

    useEffect(() {
      for (var rowContent in allRowContents) {
        if (rowContent.moviesState?.currentMovieListIsNull == true) {
          rowContent.moviesState?.refreshMovieList();
        }
      }
      return null;
    }, [true]);

    return PageStorage(
        bucket: PageStorageBucket(),
        child: ListView.builder(
            itemCount: allRowContents.length,
            itemBuilder: (context, i) {
              return allRowContents[i].buildRowContent();
            }));
  }

  _navigateToMovieDetailPage(
      BuildContext context, int movieId, List<int>? movieIds) {
    Navigator.of(context)
        .pushNamed("/movieDetail",
            arguments: MovieDetailPageArguments(movieId, movieIds))
        .then((value) {

    });
  }

  List<int>? _convertToMovieIdList(List<Movie>? movies) {
    if (movies == null) return null;

    final List<int> result = [];

    for (var movie in movies) {
      final _id = movie.id?.toInt();
      if (_id != null) result.add(_id);
    }

    return result;
  }
}
