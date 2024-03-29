import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/providers/tmdb_config_provider.dart';
import 'package:walt/ui/app_home.dart';
import 'package:walt/ui/pages/movie_detail/movie_detail_page.dart';

main() async {
  launchTmdbApp();
}

launchTmdbApp() async {
  await dotenv.load(fileName: ".env");
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.light,
      // systemNavigationBarColor: Colors.transparent,
      // systemNavigationBarDividerColor: Colors.transparent,
      // systemNavigationBarIconBrightness: Brightness.light
    ),
  );

  runApp(ProviderScope(child: HookConsumer(builder: (context, ref, child) {
    return ref.watch(tmdbConfigAsyncProvider).when(
        data: (data) {
          FlutterNativeSplash.remove();
          return MaterialApp(
            home: const AppHome(),
            onGenerateRoute: (setting) {
              if (setting.name == '/movieDetail') {
                final arguments = setting.arguments as MovieDetailPageArguments;
                return PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        MovieDetailPage(arguments.moviesStateKey),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return const FadeUpwardsPageTransitionsBuilder()
                          .buildTransitions(
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                      arguments.moviesStateKey)),
                              context,
                              animation,
                              secondaryAnimation,
                              child);
                    });
              }
              return null;
            },
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                /// 国コードでの判別は除外する。文字コードのみでサポート対象有無を判断する。
                final localeOnlyLang = Locale(locale.languageCode);
                if (supportedLocales.contains(localeOnlyLang)) {
                  return locale;
                }
              }
              return supportedLocales.first;
            },
          );
        },
        error: (error, stack) {
          return Text('Error: $error');
        },
        loading: () => const Center(child: CircularProgressIndicator()));
  })));
}
