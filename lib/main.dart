import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/constants.dart';
import 'package:walt/pages/bottom_sheet_sample_page.dart';
import 'package:walt/pages/page_storage/page_storage_sample.dart';
import 'package:walt/pages/sliver_app_bar/sliver_app_bar_flexible_space_expanded_height.dart';
import 'package:walt/pages/top_page/top_page.dart';
import 'package:walt/utils/navigation_history_observer.dart';

main() async {
  launchWaltApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light),
  );
}

launchWaltApp() {
  runApp(ProviderScope(
    child: MaterialApp(
      title: appName,
      home: SliverAppBarFlexSpaceExpandedHeightPage(),
      navigatorObservers: [NavigationHistoryObserver()],
      routes: <String, WidgetBuilder> {
        '/bottomSheetDemo': (BuildContext context) => BottomSheetDemoPage(),
      },
    ),
  ));
}
