import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/providers/movie_provider.dart';
import 'package:walt/tmdb_client_app/providers/tmdb_config_provider.dart';
import 'package:walt/tmdb_client_app/providers/watch_providers_provider.dart';
import 'package:walt/tmdb_client_app/ui/app_home.dart';
import 'package:walt/tmdb_client_app/ui/component/video_detail_page_base/video_detail_page_base.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_list_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

main() async {
  await dotenv.load(fileName: ".env");

  runApp(ProviderScope(child: HookConsumer(builder: (context, ref, child) {
    return ref.watch(tmdbConfigProvider).when(
        data: (data) {
          return const MaterialApp(home: AppHome());
        },
        error: (error, stack) {
          print(stack);
          return Text('Error: $error');
        },
        loading: () => const Center(child: CircularProgressIndicator()));
  })));
}
