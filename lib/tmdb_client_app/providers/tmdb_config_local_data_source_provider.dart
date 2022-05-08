import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/data_sources/local/tmdb_config_local_data_source.dart';

final tmdbConfigLocalDataSourceProvider = Provider<TmdbConfigLocalDataSource>(
    (ref) => TmdbConfigLocalPrefDataSource());
