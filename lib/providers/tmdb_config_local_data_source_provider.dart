import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/data_sources/local/tmdb_config_local_data_source.dart';

final tmdbConfigLocalDataSourceProvider = Provider<TmdbConfigLocalDataSource>(
    (ref) => TmdbConfigLocalPrefDataSource());
