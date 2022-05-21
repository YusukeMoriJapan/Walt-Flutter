import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walt/utils/hooks/system_hooks.dart';

class ForYouPagerIndicator extends HookConsumerWidget {
  const ForYouPagerIndicator(
      this.pagerIndicatorActiveIndex, this.indicatorLength,
      {Key? key})
      : super(key: key);
  final ValueNotifier<int> pagerIndicatorActiveIndex;
  final int indicatorLength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = useValueListenable(pagerIndicatorActiveIndex);

    return AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        effect: SlideEffect(
            activeDotColor: _useActivePagerIndicatorColor(),
            dotWidth: 8,
            dotHeight: 8,
            spacing: 16),
        count: indicatorLength,
        axisDirection: Axis.vertical);
  }

  Color _useActivePagerIndicatorColor() {
    if (useDarkModeState()) {
      return Theme.of(useContext()).colorScheme.secondary;
    } else {
      return Theme.of(useContext()).colorScheme.primary;
    }
  }
}
