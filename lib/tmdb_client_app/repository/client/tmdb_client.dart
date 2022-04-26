import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:walt/tmdb_client_app/models/responses/get_movie_response.dart';
import 'package:walt/tmdb_client_app/models/responses/get_watch_provider_response.dart';

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

  /// 追加予定
  /// ・初回リリース年で絞り込み
  /// ・一番リリース日の範囲で絞り込み
  /// ・公開日で範囲絞り込み
  /// ・vote数絞り込み
  /// ・with_people
  /// ・with_crew
  /// ・with_cast
  @GET("/{version}//discover/movie")
  Future<GetMoviesResponse> getDiscoveredMovies(
    @Path("version") int version,
    @Query("api_key") String apiKey,
    @Query("language") String language,
    @Query("region") String region,
    @Query("include_adult") String includeAdult,
    @Query("sort_by") String sortBy,
    @CancelRequest() CancelToken cancelToken, {
    @Query("vote_average.gte") double? voteAverageGte,
    @Query("vote_average.lte") double? voteAverageLte,
    @Query("year") int? year,
    @Query("with_genres") String? withGenres,
    @Query("with_keywords") String? withKeywords,
    @Query("with_original_language") String? withOriginalLanguage,
    @Query("with_watch_monetization_types") String? withWatchMonetizationTypes,
    @Query("watch_region") String? watchRegion,
  });

  @GET("/{version}/configuration")
  Future<TmdbConfig> getTmdbConfig(
    @Path("version") int version,
    @Query("api_key") String apiKey,
    @CancelRequest() CancelToken cancelToken,
  );

  @GET("/{version}/movie/{movie_id}/watch/providers")
  Future<GetWatchProviderResponse> getMovieWatchProvider(
    @Path("version") int version,
    @Query("api_key") String apiKey,
    @Path("movie_id") int movieId,
    @CancelRequest() CancelToken cancelToken,
  );
}
