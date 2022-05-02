import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/parts/builder/show_discover_page_content.dart';
import 'package:walt/tmdb_client_app/ui/view_model/movie_view_model.dart';
import 'package:walt/tmdb_client_app/use_cases/get_movies_use_case.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';
import 'package:walt/tmdb_client_app/utils/network/result.dart';

import '../../../models/entity/movie/movie.dart';
import '../../../utils/network/paging/paging_result.dart';
import 'parts/horizontal_highlighted_movie_list.dart';

class DiscoverPage extends HookConsumerWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieViewModel = ref.watch(movieViewModelProvider);

    useEffect(() {
      if (movieViewModel.trendingMovieList.currentMovieListIsNull) {
        movieViewModel.trendingMovieList.refreshMovieList();
      }
    }, [true]);
    useEffect(() {
      if (movieViewModel.upComingMovieList.currentMovieListIsNull) {
        movieViewModel.upComingMovieList.refreshMovieList();
      }
    }, [true]);
    useEffect(() {
      if (movieViewModel.popularMovieList.currentMovieListIsNull) {
        movieViewModel.popularMovieList.refreshMovieList();
      }
    }, [true]);
    useEffect(() {
      if (movieViewModel.topRatedMovieList.currentMovieListIsNull) {
        movieViewModel.topRatedMovieList.refreshMovieList();
      }
    }, [true]);

    return PageStorage(
      bucket: PageStorageBucket(),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Trending",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          showHighLightedPageContent(
              const PageStorageKey("trending"),
              const ValueKey("trendingList"),
              movieViewModel.trendingMovieList.movieListStream,
              movieViewModel.trendingMovieList.currentMovieList,
              (id) {}, () {
            movieViewModel.trendingMovieList.requestNextPageMovieList();
          }),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Up Coming",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          showHighLightedPageContent(
              const PageStorageKey("upComing"),
              const ValueKey("upComingList"),
              movieViewModel.upComingMovieList.movieListStream,
              movieViewModel.upComingMovieList.currentMovieList,
              (id) {}, () {
            movieViewModel.upComingMovieList.requestNextPageMovieList();
          }),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Top Rated",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          showHighLightedPageContent(
              const PageStorageKey("topRated"),
              const ValueKey("topRatedList"),
              movieViewModel.topRatedMovieList.movieListStream,
              movieViewModel.topRatedMovieList.currentMovieList,
              (id) {}, () {
            movieViewModel.topRatedMovieList.requestNextPageMovieList();
          }),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Popular",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          showHighLightedPageContent(
              const PageStorageKey("popular"),
              const ValueKey("popularList"),
              movieViewModel.popularMovieList.movieListStream,
              movieViewModel.popularMovieList.currentMovieList,
              (id) {}, () {
            movieViewModel.popularMovieList.requestNextPageMovieList();
          })
        ],
      ),
    );
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
