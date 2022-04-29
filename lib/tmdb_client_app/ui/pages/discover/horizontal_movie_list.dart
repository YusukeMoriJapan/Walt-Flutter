import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/models/entity/movie.dart';
import 'package:walt/tmdb_client_app/utils/throwable/not_provided_exception.dart';

final moviesHorizontalListParams = Provider<MoviesHorizontalMiniListParams>(
    (ref) =>
        throw NotProvidedException("Must override values in parent widget."));

class MoviesHorizontalList extends HookConsumerWidget {
  const MoviesHorizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dependencies = ref.watch(moviesHorizontalListParams);
    final movies = dependencies.movies;


    return ListView.builder(
      itemCount: movies.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
            onTap: () {
              dependencies.onClickMovieImage(i);
            },
            child: Image.network(movies[i].posterPath ?? ""));
      },
    );
  }
}

class MoviesHorizontalMiniListParams {
  final void Function(int id) onClickMovieImage;
  final List<Movie> movies;

  const MoviesHorizontalMiniListParams(this.onClickMovieImage, this.movies);
}
