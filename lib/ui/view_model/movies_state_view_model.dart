import 'package:flutter/widgets.dart';
import 'package:walt/constants/movie_constant.dart';
import 'package:walt/ui/states/movies_state.dart';


mixin MoviesStateViewModel {
  late final MoviesState trendingMovies;
  late final MoviesState upComingMovies;
  late final MoviesState popularMovies;
  late final MoviesState topRatedMovies;

  @protected
  late final Map<String, MoviesState> customMoviesMap;

  MoviesState? getMoviesStateFromKey(String key) {
    switch (key) {
      case trendingMovieListKey:
        return trendingMovies;
        break;
      case popularMovieListKey:
        return popularMovies;
        break;
      case topRatedMovieListKey:
        return topRatedMovies;
        break;
      case upComingMovieListKey:
        return upComingMovies;
        break;
    }
    return customMoviesMap[key];
  }

  setMoviesStateCurrentIndex(String key, int index) {
    switch (key) {
      case trendingMovieListKey:
        trendingMovies.currentIndex = index;
        break;
      case popularMovieListKey:
        popularMovies.currentIndex = index;
        break;
      case topRatedMovieListKey:
        topRatedMovies.currentIndex = index;
        break;
      case upComingMovieListKey:
        upComingMovies.currentIndex = index;
        break;
    }
    customMoviesMap[key]?.currentIndex = index;
  }

  requestNextPageMovies(String key) {
    switch (key) {
      case trendingMovieListKey:
        trendingMovies.requestNextPageMovieList();
        break;
      case popularMovieListKey:
        popularMovies.requestNextPageMovieList();
        break;
      case topRatedMovieListKey:
        topRatedMovies.requestNextPageMovieList();
        break;
      case upComingMovieListKey:
        upComingMovies.requestNextPageMovieList();
        break;
    }
    customMoviesMap[key]?.requestNextPageMovieList();
  }
}