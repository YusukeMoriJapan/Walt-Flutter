import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/discover_page.dart';
import 'package:walt/tmdb_client_app/ui/pages/favorite/favorite_page.dart';
import 'package:walt/tmdb_client_app/ui/pages/for_you/for_you_page.dart';

import '../constants/keys.dart';
import 'navigation/navigation_notifier_provider.dart';
import 'navigation/page_model.dart';

class AppHome extends HookConsumerWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageModel navigation = ref.watch(navigationProvider);

    return Scaffold(
      extendBody: true,
      body: currentScreen(navigation.index),
      bottomNavigationBar: BottomNavigationBar(
          key: Keys.NAV_BAR,
          currentIndex: navigation.index,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) {
            ref.read(navigationProvider.notifier).selectPage(index);
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: SizedBox(width: 0, height: 0), label: "FOR YOU"),
            BottomNavigationBarItem(
                icon: SizedBox(width: 0, height: 0), label: "DISCOVER"),
            BottomNavigationBarItem(
                icon: SizedBox(width: 0, height: 0), label: "FAVORITE"),
          ]),
    );
  }

  Widget currentScreen(int index) {
    switch (index) {
      case 0:
        return ForYouPage();
      case 1:
        return DiscoverPage();
      case 2:
        return FavoritePage();
      default:
        return ForYouPage();
    }
  }
}
