import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/constants/constants.dart';
import 'package:walt/tmdb_client_app/utils/utils.dart';

import '../models/responses/get_movies_result.dart';
import 'client/tmdb_client.dart';

final movieRepository =
    Provider<MovieRepository>((ref) => MovieRepositoryImpl(ref.read));

abstract class MovieRepository {
  Future<List<Movie>?> getPopularMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region});
}

class MovieRepositoryImpl implements MovieRepository {
  final Reader read;

  MovieRepositoryImpl(this.read);

  @override
  Future<List<Movie>?> getPopularMovies(
      {required Language language,
      required int page,
      required int apiVersion,
      required String region,
      CancelToken? cancelToken}) async {
    try {
      final response = await read(tmdbClientProvider)
          .get('/3/tv/popular?api_key=${getTmdbApiKey()}', cancelToken: cancelToken);
      return GetMoviesResult.fromJson(response.data).results;
    } on DioError catch (error) {
      // throw DataException.fromDioError(error);
      /// 何らかの例外を出す
    }
    return null;
  }
}

enum Language { japanese, englishUs }

extension LanguageEx on Language {
  String get name {
    switch (this) {
      case Language.englishUs:
        return 'en-US';
      case Language.japanese:
        return 'ja';
    }
  }
}
