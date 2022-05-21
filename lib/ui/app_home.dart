import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/ui/pages/discover/discover_page.dart';
import 'package:walt/ui/pages/favorite/favorite_page.dart';
import 'package:walt/ui/pages/for_you/for_you_page.dart';
import 'package:walt/utils/hooks/system_hooks.dart';

import '../constants/keys.dart';
import 'navigation/navigation_bar_event.dart';
import 'navigation/navigation_notifier_provider.dart';
import 'navigation/page_model.dart';

class AppHome extends HookConsumerWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageModel navigation = ref.watch(navigationProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: currentScreen(navigation),
      bottomNavigationBar: SizedBox(
        child: HookConsumer(builder: (context, ref, child) {
          return BottomNavigationBar(
              key: Keys.NAV_BAR,
              currentIndex: navigation.index,
              backgroundColor:
                  _getBottomNavigationColor(navigation, useDarkModeState()),
              unselectedItemColor: _getUnSelectedItemColor(navigation),
              elevation: _getBottomNavigationElevation(navigation),
              onTap: (index) {
                ref.watch(navigationProvider.notifier).selectPage(index);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: SizedBox(width: 0, height: 0), label: "FOR YOU"),
                BottomNavigationBarItem(
                    icon: SizedBox(width: 0, height: 0), label: "DISCOVER"),
                // BottomNavigationBarItem(
                //     icon: SizedBox(width: 0, height: 0), label: "FAVORITE"),
              ]);
        }),
      ),
    );
  }

  Widget currentScreen(PageModel pageModel) {
    switch (pageModel.page) {
      case NavigationBarEvent.forYou:
        return const ForYouPage();
      case NavigationBarEvent.discover:
        return const DiscoverPage();
      case NavigationBarEvent.favorite:
        return const FavoritePage();
      default:
        return const ForYouPage();
    }
  }

  double _getBottomNavigationElevation(PageModel navigation) {
    if (navigation.page == NavigationBarEvent.forYou) {
      return 0.0;
    } else {
      return 10.0;
    }
  }

  Color? _getBottomNavigationColor(PageModel navigation, bool isDarkMode) {
    if (navigation.page == NavigationBarEvent.forYou) {
      return Colors.transparent;
    } else {
      if (isDarkMode) {
        return null;
      } else {
        return Colors.white;
      }
    }
  }

  Color? _getUnSelectedItemColor(PageModel pageModel) {
    if (pageModel.page == NavigationBarEvent.forYou) {
      return Colors.white;
    } else {
      return null;
    }
  }
}
