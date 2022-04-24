import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tmdbClientProvider = Provider((ref) =>
    Dio(BaseOptions(headers: {}, baseUrl: 'https://api.themoviedb.org')));