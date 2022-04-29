import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

main() {
  runApp(ProviderScope(
      child: MaterialApp(
    home: Scaffold(
      body: _test2(),
    ),
  )));
}

Widget _test2() {
  return HookConsumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final Size size = MediaQuery.of(context).size;

    final controller = useRef(YoutubePlayerController(
      initialVideoId: 'youtubeのIDをここに入れる',
      flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          useHybridComposition: false,
          loop: true,
          disableDragSeek: true,
          hideControls: true,
          forceHD: true,
          controlsVisibleAtStart: false),
    ));

    return YoutubePlayerBuilder(
        player: YoutubePlayer(
            controller: controller.value,
            showVideoProgressIndicator: false,
            onReady: () {}),
        builder: (context, player) {
          return SizedBox(width: 150, height: (150) * (9 / 16), child: player);
        });
  });
}

Widget _test() {
  return HookConsumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final controller = useRef(YoutubePlayerController(
      initialVideoId: 'kl8F-8tR8to',
      flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          useHybridComposition: false,
          loop: true,
          disableDragSeek: true,
          hideControls: true,
          forceHD: true,
          controlsVisibleAtStart: false),
    ));

    return Container(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: 3.5,
        child: YoutubePlayerBuilder(
            player: YoutubePlayer(
                controller: controller.value,
                showVideoProgressIndicator: false,
                onReady: () {}),
            builder: (context, player) {
              return ClipRect(
                  child: Align(
                      widthFactor: 0.3164, heightFactor: 1, child: player));
            }),
      ),
    );
  });
}
