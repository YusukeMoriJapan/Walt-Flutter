import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/ui/navigation/page_model.dart';

import 'navigation_bar_event.dart';

class NavigationNotifier extends StateNotifier<PageModel> {
  NavigationNotifier() : super(defaultPage);

  static const defaultPage = PageModel(NavigationBarEvent.forYou, 0);

  void selectPage(int i) {
    switch (i) {
      case 0:
        state = PageModel(NavigationBarEvent.forYou, i);
        break;
      case 1:
        state = PageModel(NavigationBarEvent.discover, i);
        break;
      case 2:
        state = PageModel(NavigationBarEvent.favorite, i);
        break;
    }
  }
}