import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:walt/tmdb_client_app/models/entity/movie/movie.dart';

class NormalMoviesHorizontalList extends HookConsumerWidget {
  const NormalMoviesHorizontalList(this.movies, this.onClickMovieImage,
      this._scrollController, this.baseImageUrl,
      {Key? key})
      : super(key: key);

  final List<Movie> movies;
  final void Function(int id) onClickMovieImage;
  final ScrollController _scrollController;
  final String baseImageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: movies.length,
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: _imageHPadding(i)),
          child: InkWell(
              onTap: () {
                final id = movies[i].id?.toInt();
                if (id != null) onClickMovieImage(id);
              },

              ///TODO FIX 画像サイズをInjectするべき
              child: Container(
                color: Color.fromARGB(255, 165, 165, 165),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: baseImageUrl + _getProfilePath(movies[i].posterPath),
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150 * 0.71,
                ),
              )),
        );
      },
    );
  }

  String _getProfilePath(String? path) => path ?? "";

  _imageHPadding(int i) {
    if (i != 0 || i != movies.length - 1) {
      return 2.0;
    } else {
      return 0.0;
    }
  }
}
