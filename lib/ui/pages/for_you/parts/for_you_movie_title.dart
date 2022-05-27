import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/entity/movie/movie.dart';

class ForYouMovieTitle extends HookConsumerWidget {
  const ForYouMovieTitle(this.selectedMovieNotifier, {Key? key})
      : super(key: key);
  final ValueNotifier<Movie?> selectedMovieNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMovie = useValueListenable(selectedMovieNotifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(selectedMovie?.title ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              // fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 255, 255, 255),
            ))
      ],
    );
  }
}
