import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:walt/tmdb_client_app/models/responses/get_movie_result.dart';

import '../../models/config/tmdb_config.dart';

part 'tmdb_client.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/")
abstract class TmdbClient {
  factory TmdbClient(Dio dio, {String baseUrl}) = _TmdbClient;

  @GET("/{version}/movie/popular")
  Future<GetMoviesResponse> getPopularMovies(
    @Path("version") int version,
    @Query("api_key") String apiKey,
    @CancelRequest() CancelToken cancelToken,
  );

  @GET('/{version}/trending/movie/{timeWindow}')
  Future<GetMoviesResponse> getTrendingMovies(
    @Path("version") int version,
    @Path("timeWindow") String timeWindow,
    @Query("api_key") String apiKey,
    @CancelRequest() CancelToken cancelToken,
  );

  @GET("/{version}/movie/upcoming")
  Future<GetMoviesResponse> getUpComingMovies(
    @Path("version") int version,
    @Query("api_key") String apiKey,
    @CancelRequest() CancelToken cancelToken,
  );

  @GET("/{version}/movie/top_rated")
  Future<GetMoviesResponse> getTopRatedMovies(
    @Path("version") int version,
    @Query("api_key") String apiKey,
    @CancelRequest() CancelToken cancelToken,
  );

  @GET("/{version}/configuration")
  Future<TmdbConfig> getTmdbConfig(
    @Path("version") int version,
    @Query("api_key") String apiKey,
    @CancelRequest() CancelToken cancelToken,
  );
}
