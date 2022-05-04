import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/discover_row_content.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/parts/builder/show_discover_page_content.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/ui_model/row_content.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/movie_detail_page.dart';
import 'package:walt/tmdb_client_app/ui/view_model/movie_view_model.dart';
import 'package:walt/tmdb_client_app/use_cases/get_movies_use_case.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';
import 'package:walt/tmdb_client_app/utils/network/result.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../models/entity/movie/movie_list.dart';
import '../../../utils/network/paging/paging_result.dart';
import 'parts/horizontal_highlighted_movie_list.dart';

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

    final allRowContents = useRef<List<RowContent>>([
      RowContent(
          headerName: "Trending",
          key: const PageStorageKey("trending"),
          listKey: const ValueKey("trending"),
          movieList: movieViewModel.trendingMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted),
      RowContent(
          headerName: "Up Coming",
          key: const PageStorageKey("upComing"),
          listKey: const ValueKey("upComing"),
          movieList: movieViewModel.upComingMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted),
      RowContent(
          headerName: "Popular",
          key: const PageStorageKey("popular"),
          listKey: const ValueKey("popular"),
          movieList: movieViewModel.popularMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted),
      RowContent(
          headerName: "TopRated",
          key: const PageStorageKey("topRated"),
          listKey: const ValueKey("topRated"),
          movieList: movieViewModel.topRatedMovieList,
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.highLighted),
      RowContent(
          headerName: "Anime",
          key: const PageStorageKey(animeKey),
          listKey: const ValueKey(animeKey),
          movieList: movieViewModel.getCustomMovieList(animeKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal),
      RowContent(
          headerName: "Romance",
          key: const PageStorageKey(romanceKey),
          listKey: const ValueKey(romanceKey),
          movieList: movieViewModel.getCustomMovieList(romanceKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal),
      RowContent(
          headerName: "Thriller",
          key: const PageStorageKey(thrillerKey),
          listKey: const ValueKey(thrillerKey),
          movieList: movieViewModel.getCustomMovieList(thrillerKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal),
      RowContent(
          headerName: "Science Fiction",
          key: const PageStorageKey(sfKey),
          listKey: const ValueKey(sfKey),
          movieList: movieViewModel.getCustomMovieList(sfKey),
          onClickMovieImage: (id) => _navigateToMovieDetailPage(context, id),
          type: DiscoverRowContentType.normal),
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
      child: ListView(
        children: useRef(_spreadWidgetList(allRowContents)).value,
      ),
    );
  }

  List<Widget> _spreadWidgetList(List<RowContent> allRowContents) {
    final List<Widget> allRowWidgets = [];

    allRowContents
        .map((rowContent) => rowContent.buildRowContent())
        .forEach((widgetList) {
      widgetList.forEach((widget) {
        allRowWidgets.add(widget);
      });
    });

    return allRowWidgets;
  }

  _navigateToMovieDetailPage(BuildContext context, int movieId) {
    Navigator.of(context).pushNamed("/movieDetail",
        arguments: MovieDetailPageArguments(movieId));
  }
}

class DiscoverPageContent extends HookConsumerWidget {
  const DiscoverPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final List<Movie> trendingMovie
    // final List<Movie> upComingMovie
    // final List<Movie> topRatedMovie
    // final List<Movie> popularMovie

    //Header Chipたくさんあり

    return ListView.builder(
        itemCount: 1, //縦の要素数
        itemBuilder: (BuildContext context, int index) {
          //直和型のwhenで網羅する
          return const Text("");
          //パターン1　(Trending, Popular)

          //パターン2  (映像コンテンツ一覧　とかアニメとか)

          //パターン3  (何か)
        });

    const Text("Trending");
    const Text("Up Coming");
    const Text("Top Rated");
    const Text("Popular");
  }
}
