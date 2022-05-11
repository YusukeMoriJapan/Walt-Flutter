import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/models/config/tmdb_config.dart';
import 'package:walt/tmdb_client_app/repository/tmdb_config_repository.dart';
import 'package:walt/tmdb_client_app/utils/log/logger.dart';
import 'package:walt/tmdb_client_app/utils/throwable/illegal_state_exception.dart';
import 'package:walt/tmdb_client_app/utils/throwable/not_provided_exception.dart';

import '../utils/network/result.dart';

final tmdbConfigAsyncProvider = FutureProvider<Result<TmdbConfig>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() {
    cancelToken.cancel();
  });

  return await ref
      .read(tmdbConfigRepository)
      .getTmdbConfig(apiVersion: 3, cancelToken: cancelToken);
});

final Provider<TmdbConfig> tmdbConfigProvider = Provider((ref) {
  final asyncResult = ref.read(tmdbConfigAsyncProvider).value;

  if (asyncResult == null) {
    throw IllegalStateException('It is not allowed to call tmdbConfigProvider'
        ' before the acquisition process of tmdbAsyncProvider is completed.');
  }

  final tmdbConfig = asyncResult.whenOrNull(success: (config) => config);

  if (tmdbConfig == null) {
    throw NotProvidedException('Tmdb Config is null.');
  }

  return tmdbConfig;
});

final Provider<String> baseImageUrlProvider = Provider((ref) {
  final baseImageUrl = ref.read(tmdbConfigProvider).images?.secureBaseUrl;
  if (baseImageUrl == null) {
    throw NotProvidedException('base image URL is null.');
  }

  return baseImageUrl;
});

final ProviderFamily<String, int> posterImagePathProvider =
    Provider.family<String, int>((ref, targetWidth) {
  final posterSizes = ref.read(tmdbConfigProvider).images?.posterSizes;
  final baseUrl = ref.read(baseImageUrlProvider);

  return baseUrl + _extractTargetImageSizePath(posterSizes, targetWidth);
});

final ProviderFamily<String, int> backdropImagePathProvider =
    Provider.family<String, int>((ref, targetWidth) {
  final backdropSizes = ref.read(tmdbConfigProvider).images?.backdropSizes;
  final baseUrl = ref.read(baseImageUrlProvider);

  return baseUrl + _extractTargetImageSizePath(backdropSizes, targetWidth);
});

final ProviderFamily<String, int> profileImagePathProvider =
    Provider.family<String, int>((ref, targetWidth) {
  final backdropSizes = ref.read(tmdbConfigProvider).images?.profileSizes;
  final baseUrl = ref.read(baseImageUrlProvider);

  return baseUrl + _extractTargetImageSizePath(backdropSizes, targetWidth);
});

String _extractTargetImageSizePath(List<String>? sizeList, int targetWidth) {
  if (sizeList == null) {
    logger.e(
        "Assigned default original image path instead since sizeList is null.");
    return defaultOriginalImagePath;
  }

  String? matchedSizeString;
  int? lastDiff;

  sizeList.forEach((sizeString) {
    final _lastDiff = lastDiff;
    final int _diff;

    try {
      _diff =
          (int.parse(sizeString.replaceAll(RegExp('[^0-9]'), '')) - targetWidth)
              .abs();
    } catch (e) {
      logger.w("Failed to parse imageSizeString.", e);
      return;
    }

    if (_lastDiff == null) {
      matchedSizeString = sizeString;
      lastDiff = _diff;
      return;
    }

    if (_diff < _lastDiff) {
      matchedSizeString = sizeString;
      lastDiff = _diff;
      return;
    } else {
      return;
    }
  });

  final _matchedSizeString = matchedSizeString;
  if (_matchedSizeString == null) {
    logger.e("Any matched image size is matched.");
    return defaultOriginalImagePath;
  } else {
    return _matchedSizeString;
  }
}
