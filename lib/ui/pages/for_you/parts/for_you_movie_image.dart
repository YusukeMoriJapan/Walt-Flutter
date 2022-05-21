import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/providers/tmdb_config_provider.dart';

class ForYouMovieImage extends HookConsumerWidget {
  const ForYouMovieImage(
      {required this.index,
      required this.onTapImage,
      required this.posterPath,
      Key? key})
      : super(key: key);
  final int index;
  final String posterPath;
  final void Function(int index) onTapImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Image.network(
          /// nullハンドリング必要
          ref.watch(posterImagePathProvider(780)) + posterPath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              final expectedBytes = loadingProgress.expectedTotalBytes ?? 0;
              return SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                    value:
                        loadingProgress.cumulativeBytesLoaded / expectedBytes),
              );
            }
          },
        ),
        Positioned.fill(
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  // splashColor: Colors.lightGreenAccent,
                  onTap: () {
                    onTapImage(index);
                  },
                ))),
      ],
    );
  }
}
