import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/providers/tmdb_config_provider.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/ui_model/row_content.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/movie_detail_page.dart';
import 'package:walt/tmdb_client_app/ui/view_model/movie_view_model.dart';

const animeKey = "popularAnime";
const romanceKey = "popularRomance";
const thrillerKey = "popularThriller";
const sfKey = "popularScienceFiction";

class DiscoverPage extends HookConsumerWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieViewModel = ref.watch(movieViewModelProvider);

    useEffect(() {
      movieViewModel.registerCustomDiscoveredMovieList(
          animeKey, "16", "popularity.desc");
      movieViewModel.registerCustomDiscoveredMovieList(
          romanceKey, "10749", "popularity.desc");
      movieViewModel.registerCustomDiscoveredMovieList(
          thrillerKey, "53", "popularity.desc");
      movieViewModel.registerCustomDiscoveredMovieList(
          sfKey, "878", "popularity.desc");
    }, [true]);

    final allRowContents = useRef<List<DiscoverRowContentUiModel>>([
      DiscoverRowContentUiModel(
          headerName: "Trending",
          key: const PageStorageKey("trending"),
          listKey: const ValueKey("trending"),
          movieList: movieViewModel.trendingMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Up Coming",
          key: const PageStorageKey("upComing"),
          listKey: const ValueKey("upComing"),
          movieList: movieViewModel.upComingMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Popular",
          key: const PageStorageKey("popular"),
          listKey: const ValueKey("popular"),
          movieList: movieViewModel.popularMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "TopRated",
          key: const PageStorageKey("topRated"),
          listKey: const ValueKey("topRated"),
          movieList: movieViewModel.topRatedMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Anime",
          key: const PageStorageKey(animeKey),
          listKey: const ValueKey(animeKey),
          movieList: movieViewModel.getCustomMovieList(animeKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Romance",
          key: const PageStorageKey(romanceKey),
          listKey: const ValueKey(romanceKey),
          movieList: movieViewModel.getCustomMovieList(romanceKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Thriller",
          key: const PageStorageKey(thrillerKey),
          listKey: const ValueKey(thrillerKey),
          movieList: movieViewModel.getCustomMovieList(thrillerKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
      DiscoverRowContentUiModel(
          headerName: "Science Fiction",
          key: const PageStorageKey(sfKey),
          listKey: const ValueKey(sfKey),
          movieList: movieViewModel.getCustomMovieList(sfKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal,
          backdropImageUrl: ref.read(backdropImagePathProvider(780)),
          posterImageUrl: ref.read(posterImagePathProvider(342))),
    ]).value;

    useEffect(() {
      allRowContents.forEach((rowContent) {
        if (rowContent.movieList?.currentMovieListIsNull == true) {
          rowContent.movieList?.refreshMovieList();
        }
      });
    }, [true]);

    return PageStorage(
        bucket: PageStorageBucket(),
        child: ListView.builder(
            itemCount: allRowContents.length,
            itemBuilder: (context, i) {
              return allRowContents[i].buildRowContent();
            }));
  }

  _navigateToMovieDetailPage(BuildContext context, int movieId) {
    Navigator.of(context).pushNamed("/movieDetail",
        arguments: MovieDetailPageArguments(movieId));
  }
}
