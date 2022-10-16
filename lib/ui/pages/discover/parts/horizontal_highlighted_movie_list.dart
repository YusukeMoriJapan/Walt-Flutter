import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:walt/models/entity/movie/movie.dart';

class HighlightedMoviesHorizontalList extends StatefulWidget {
  const HighlightedMoviesHorizontalList(this.movies, this.onClickMovieImage,
      this._scrollController, this.baseImageUrl,
      {Key? key})
      : super(key: key);

  final List<Movie> movies;
  final void Function(int id) onClickMovieImage;
  final AutoScrollController _scrollController;
  final String baseImageUrl;

  @override
  State<StatefulWidget> createState() => _HighlightedMoviesHorizontalListState();
}

class _HighlightedMoviesHorizontalListState
    extends State<HighlightedMoviesHorizontalList>
    with AutomaticKeepAliveClientMixin {
  _HighlightedMoviesHorizontalListState();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.movies.length,
      scrollDirection: Axis.horizontal,
      controller: widget._scrollController,
      itemBuilder: (BuildContext context, int i) {
        return AutoScrollTag(
          controller: widget._scrollController,
          index: i,
          key: ValueKey(i),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _imageHPadding(i)),
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
                      image: widget.baseImageUrl +
                          _getProfilePath(widget.movies[i].backdropPath),
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
                        widget.movies[i].title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
                Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          // splashColor: Colors.lightGreenAccent,
                          onTap: () {
                            widget.onClickMovieImage(i);
                          },
                        ))),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getProfilePath(String? path) => path ?? "";

  _imageHPadding(int i) {
    if (i != 0 || i != widget.movies.length - 1) {
      return 4.0;
    } else {
      return 0.0;
    }
  }
}
