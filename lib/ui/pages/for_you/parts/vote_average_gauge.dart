import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/entity/movie/movie.dart';

import '../../../../utils/hooks/system_hooks.dart';

class VoteAverageGauge extends HookConsumerWidget {
  const VoteAverageGauge(this.selectedMovie, {Key? key}) : super(key: key);
  final ValueNotifier<Movie> selectedMovie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMovieValue = useValueListenable(selectedMovie);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: HookConsumer(builder: (context, ref, child) {
            final isDarkMode = useDarkModeState();
            Color color;
            if (isDarkMode) {
              color = Theme.of(context).colorScheme.secondary;
            } else {
              color = Theme.of(context).colorScheme.primary;
            }

            return CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: const Color.fromARGB(102, 158, 158, 158),
                color: color,
                value: selectedMovieValue.getVoteAverageForIndicator());
          }),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedMovieValue.getVoteAverageForText().toString(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const Text(
              "%",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
