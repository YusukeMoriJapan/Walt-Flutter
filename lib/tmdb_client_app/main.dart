import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/providers/tmdb_config_provider.dart';
import 'package:walt/tmdb_client_app/ui/app_home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/movie_detail_page.dart';

main() async {
  launchTmdbApp();
}

launchTmdbApp() async {
  await dotenv.load(fileName: ".env");

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      // systemNavigationBarColor: Colors.transparent,
      // systemNavigationBarDividerColor: Colors.transparent,
      // systemNavigationBarIconBrightness: Brightness.light
    ),
  );

  runApp(ProviderScope(child: HookConsumer(builder: (context, ref, child) {
    return ref.watch(tmdbConfigProvider).when(
        data: (data) {
          return MaterialApp(
            home: const AppHome(),
            onGenerateRoute: (setting) {
              if (setting.name == '/movieDetail') {
                final arguments = setting.arguments as MovieDetailPageArguments;
                return MaterialPageRoute(
                    builder: (context) => MovieDetailPage(arguments.movieId));
              }
            },
          );
        },
        error: (error, stack) {
          print(stack);
          return Text('Error: $error');
        },
        loading: () => const Center(child: CircularProgressIndicator()));
  })));
}
