import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/models/entity/movie.dart';
import 'package:walt/tmdb_client_app/utils/throwable/not_provided_exception.dart';

final someHorizontalMovieListParams = Provider<SomeHorizontalMovieListParams>(
        (ref) =>
    throw NotProvidedException("Must override values in parent widget."));

class SomeHorizontalMovieList extends HookConsumerWidget {
  const SomeHorizontalMovieList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dependencies = ref.watch(someHorizontalMovieListParams);
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

class SomeHorizontalMovieListParams {
  final void Function(int id) onClickMovieImage;
  final List<Movie> movies;

  const SomeHorizontalMovieListParams(this.onClickMovieImage, this.movies);
}