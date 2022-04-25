import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/client/tmdb_client.dart';

final tmdbClientProvider = Provider((ref) =>
    TmdbClient(Dio()..interceptors.add(LogInterceptor(responseBody: true))));

