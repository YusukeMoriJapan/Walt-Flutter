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
  final double imageHeight = 150;

  double get imageWidth => imageHeight * 0.71;
  final itemPadding = const EdgeInsets.symmetric(horizontal: 4);

  double get itemExtent => imageWidth + itemPadding.horizontal;

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
      /// itemExtentを指定しないと縦スクロールでかくつくため、itemExtentは指定必須
      itemExtent: widget.itemExtent,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      scrollDirection: Axis.horizontal,
      controller: widget._scrollController,
      itemBuilder: (BuildContext context, int i) {
        return AutoScrollTag(
          index: i,
          controller: widget._scrollController,
          key: ValueKey(i),
          child: Padding(
            padding: widget.itemPadding,
            child: Stack(
              children: [
                Container(
                  color: const Color.fromARGB(255, 165, 165, 165),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.baseImageUrl +
                        _getProfilePath(widget.movies[i].posterPath),
                    fit: BoxFit.cover,
                    height: widget.imageHeight,
                    width: widget.imageWidth,
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
}
