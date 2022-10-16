import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:walt/models/entity/movie/movie.dart';

class NormalMoviesHorizontalList extends StatefulWidget {
  const NormalMoviesHorizontalList(this.movies, this.onClickMovieImage,
      this._scrollController, this.baseImageUrl,
      {Key? key})
      : super(key: key);

  final List<Movie> movies;
  final void Function(int index) onClickMovieImage;
  final AutoScrollController _scrollController;
  final String baseImageUrl;

  @override
  State<StatefulWidget> createState() {
    return _NormalMoviesHorizontalListState();
  }
}

class _NormalMoviesHorizontalListState extends State<NormalMoviesHorizontalList>
    with AutomaticKeepAliveClientMixin {
  _NormalMoviesHorizontalListState();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: widget.movies.length,
      scrollDirection: Axis.horizontal,
      controller: widget._scrollController,
      itemBuilder: (BuildContext context, int i) {
        return AutoScrollTag(
          index: i,
          controller: widget._scrollController,
          key: ValueKey(i),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _imageHPadding(i)),
            child: Stack(
              children: [
                Container(
                  color: const Color.fromARGB(255, 165, 165, 165),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.baseImageUrl +
                        _getProfilePath(widget.movies[i].posterPath),
                    fit: BoxFit.cover,
                    height: 150,
                    width: 150 * 0.71,
                  ),
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
