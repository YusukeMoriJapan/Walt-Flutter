import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/utils/hooks/system_hooks.dart';

import '../../../../../utils/ui/icons.dart';

class VideoDetailAppBar extends HookConsumerWidget {
  const VideoDetailAppBar(this.videoDetailAppBarFlexSpace, {Key? key})
      : super(key: key);

  final maxAppBarHeight = 350.0;
  final Widget videoDetailAppBarFlexSpace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = useDarkModeState();

    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 3,
      backgroundColor: _getAppBarBackgroundColor(isDarkMode),
      actions: [
        IconButton(
            icon: const ShadowIcon(
              Icons.close,
              color: Colors.black,
              backgroundColor: Color.fromARGB(76, 255, 255, 255),
              shadowColor: Colors.transparent,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ],
      pinned: true,
      stretch: true,
      expandedHeight: maxAppBarHeight,
      flexibleSpace: videoDetailAppBarFlexSpace,
      floating: false,
    );
  }
}

Color? _getAppBarBackgroundColor(bool isDarkMode) {
  if (isDarkMode) {
    return null;
  } else {
    return Colors.white;
  }
}
