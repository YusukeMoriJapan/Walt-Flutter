import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:walt/models/entity/movie/movie.dart';

class HighlightedMoviesHorizontalList extends HookConsumerWidget {
  const HighlightedMoviesHorizontalList(this.movies, this.onClickMovieImage,
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
              child: Stack(
                children: [
                  Container(
                    foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                          Colors.transparent,
                          Colors.black,
                        ])),
                    child: Container(
                      color: const Color.fromARGB(255, 165, 165, 165),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: baseImageUrl +
                            _getProfilePath(movies[i].backdropPath),
                        height: 150,
                        width: 150 * 1.78,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size(200, double.infinity)),
                    child: Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          movies[i].title ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        )),
                  )
                ],
              )),
        );
      },
    );
  }

  String _getProfilePath(String? path) => path ?? "";

  _imageHPadding(int i) {
    if (i != 0 || i != movies.length - 1) {
      return 4.0;
    } else {
      return 0.0;
    }
  }
}
