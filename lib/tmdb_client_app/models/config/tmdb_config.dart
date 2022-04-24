import '../responses/get_tmdb_config_result.dart';

class TmdbConfig {
  final TmdbImageConfig images;
  final List<String> changeKeys;

  const TmdbConfig(this.images, this.changeKeys);
}
