import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:walt/tmdb_client_app/models/config/tmdb_config.dart';

import '../../utils/log/logger.dart';

abstract class TmdbConfigLocalDataSource {
  Future<void> setTmdbConfig(TmdbConfig newConfig);

  Future<int?> getLastTimeSetTmdbConfig();

  Future<TmdbConfig?> getTmdbConfig();
}

class TmdbConfigLocalPrefDataSource extends TmdbConfigLocalDataSource {
  static const tmdbConfigPrefKey = "tmdbConfigPrefKey";
  static const lastTimeGetTmdbConfigKey = "lastTimeGetTmdbConfigKey";

  @override
  Future<void> setTmdbConfig(TmdbConfig newConfig) async {
    try {
      final pref = await SharedPreferences.getInstance();
      pref.setString(tmdbConfigPrefKey, json.encode(newConfig.toJson()));
      pref.setInt(lastTimeGetTmdbConfigKey,
          DateTime.now().toUtc().millisecondsSinceEpoch);
      return;
    } catch (e, sT) {
      logger.e("Failed to set TMDB Config from Local Pref DataSource.", e, sT);
      rethrow;
    }
  }

  @override
  Future<TmdbConfig?> getTmdbConfig() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final tmdbConfigRawJson = pref.getString(tmdbConfigPrefKey);
      if (tmdbConfigRawJson == null) return null;

      return TmdbConfig.fromJson(json.decode(tmdbConfigRawJson));
    } catch (e, sT) {
      logger.e("Failed to get TMDB Config from Local Pref DataSource.", e, sT);
      return null;
    }
  }

  @override
  Future<int?> getLastTimeSetTmdbConfig() async {
    try {
      final pref = await SharedPreferences.getInstance();
      return pref.getInt(lastTimeGetTmdbConfigKey);
    } catch (e, sT) {
      logger.e(
          "Failed to get LastTimeSetTmdbConfig from Local Pref DataSource.",
          e,
          sT);
      return null;
    }
  }
}
