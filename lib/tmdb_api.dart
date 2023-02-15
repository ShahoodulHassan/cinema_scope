import 'package:dio/dio.dart';
import 'package:retrofit/http.dart' as http;

import 'models/configuration.dart';
import 'models/movie.dart';
import 'models/person.dart';
import 'models/search.dart';

part 'tmdb_api.g.dart';

@http.RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TmdbApi {
  static const String apiKey = 'ec7b57c566e8af94115bb2c0d910f610';
  static const String accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g';

  factory TmdbApi(Dio dio, {String baseUrl}) = _TmdbApi;

  static const Map<String, dynamic> headerMap = {
    "Content-Type": "application/json;charset=utf-8",
    "Authorization": "Bearer $accessToken"
  };

  /// Configuration retrieval methods

  @http.GET("/configuration")
  @http.Headers(headerMap)
  Future<ApiConfiguration> getApiConfiguration();

  @http.GET("/configuration/countries")
  @http.Headers(headerMap)
  Future<List<CountryConfig>> getCountryConfiguration();

  @http.GET("/configuration/languages")
  @http.Headers(headerMap)
  Future<List<LanguageConfig>> getLanguageConfiguration();

  @http.GET("/configuration/primary_translations")
  @http.Headers(headerMap)
  Future<List<String>> getTranslationConfiguration();

  @http.GET("/genre/{media_type}/list")
  @http.Headers(headerMap)
  Future<GenreResult> getGenres(
    @http.Path("media_type") String mediaType, {
    @http.Query('language') String language = 'en-US',
  });

  /// Media retrieval method

  @http.GET("/movie/{id}")
  @http.Headers(headerMap)
  Future<Movie> getMovie(@http.Path("id") int id);

  @http.GET("/movie/{id}")
  @http.Headers(headerMap)
  Future<Movie> getMovieWithDetail(
    @http.Path("id") int id, {
    @http.Query('language') String language = 'en-US',
    @http.Query('append_to_response') String append =
        'videos,images,recommendations,keywords,reviews,credits,release_dates',
    @http.Query('include_image_language') String imageLanguage = 'en,null',
  });

  /// https://api.themoviedb.org/3/discover/movie?
  /// api_key=ec7b57c566e8af94115bb2c0d910f610&language=en-US&region=US
  /// &with_people=65731|4888&sort_by=vote_average.desc&include_adult=false
  /// &page=1&vote_average.gte=6.1&vote_count.gte=100
  @http.GET("/discover/movie")
  @http.Headers(headerMap)
  Future<CombinedResults> getMoreMoviesByLeadActors(
      @http.Query('with_people') String withPeople, {
        @http.Query('language') String language = 'en-US',
        @http.Query('region') String region = 'US',
        @http.Query('sort_by') String sortBy = 'vote_average.desc',
        @http.Query('include_adult') String includeAdult = 'false',
        @http.Query("page") int page = 1,
        @http.Query("vote_average.gte") double voteAverage = 6.1,
        @http.Query("vote_count.gte") int voteCount = 100,
      });

  /// https://api.themoviedb.org/3/discover/movie?
  /// api_key=ec7b57c566e8af94115bb2c0d910f610&language=en-US&region=US
  /// &sort_by=vote_average.desc&include_adult=false&include_video=false
  /// &page=1&with_genres=878,12|878,28|12,28&vote_average.gte=6.1
  /// &vote_count.gte=100&primary_release_year=2022
  @http.GET("/discover/movie")
  @http.Headers(headerMap)
  Future<CombinedResults> getMoreMoviesByGenres(
      @http.Query('with_genres') String withGenres,
      @http.Query('primary_release_date.gte') String releaseDateGte,
      @http.Query('primary_release_date.lte') String releaseDateLte,
      // @http.Query('without_genres') String withoutGenres,
      /*@http.Query("with_keywords") String withKeywords,*/
      /*@http.Query('primary_release_year') String primaryReleaseYear,*/ {
        @http.Query('language') String language = 'en-US',
        @http.Query('with_original_language') String originalLanguage = 'en',
        @http.Query('region') String region = 'US',
        @http.Query('sort_by') String sortBy = 'vote_average.desc',

        @http.Query('include_adult') String includeAdult = 'false',
        @http.Query("page") int page = 1,

        @http.Query("vote_average.gte") double voteAverage = 6.1,
        @http.Query("vote_count.gte") int voteCount = 100,
      });

  /// https://api.themoviedb.org/3/search/movie?
  /// api_key=ec7b57c566e8af94115bb2c0d910f610&language=en-US&page=1
  /// &include_adult=true&region=US&query=Jack+Reacher
  @http.GET("/search/movie")
  @http.Headers(headerMap)
  Future<MovieSearchResult> searchMovies(
    @http.Query("query") String query, {
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en',
    @http.Query('include_adult') String includeAdult = 'false',
    @http.Query('region') String region = 'US',
  });

  /// https://api.themoviedb.org/3/search/person?api_key=ec7b57c566e8af94115bb2c0d910f610&language=en-US&page=1&include_adult=true&region=US&query=Jack
  @http.GET("/search/person")
  @http.Headers(headerMap)
  Future<PersonSearchResult> searchPersons(
    @http.Query("query") String query, {
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en',
    @http.Query('include_adult') String includeAdult = 'false',
    @http.Query('region') String region = 'US',
  });

  /// https://api.themoviedb.org/3/search/multi?api_key=ec7b57c566e8af94115bb2c0d910f610&language=en-US&query=jack&page=10&include_adult=true&region=US
  @http.GET("/search/multi")
  @http.Headers(headerMap)
  Future<MultiSearchResult> performMultiSearch(
    @http.Query("query") String query, {
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en',
    @http.Query('include_adult') String includeAdult = 'false',
    @http.Query('region') String region = 'US',
  });

  /// https://api.themoviedb.org/3/discover/movie?
  /// api_key=ec7b57c566e8af94115bb2c0d910f610&page=1&language=en-US
  /// &release_date.gte=2023-01-07&release_date.lte=2023-01-15
  /// &sort_by=release_date.desc&with_original_language=en
  @http.GET("/discover/movie")
  @http.Headers(headerMap)
  Future<MovieSearchResult> getLatestMovies(
      @http.Query('release_date.gte') String dateGte,
      @http.Query('release_date.lte') String dateLte,
      {@http.Query("page") int page = 1,
      @http.Query('language') String language = 'en-US',
      @http.Query('sort_by') String sortBy = 'release_date.desc',
      @http.Query('include_adult') String includeAdult = 'false',
      @http.Query('with_original_language') String withLanguage = 'en'});

  @http.GET("/movie/popular")
  @http.Headers(headerMap)
  Future<MovieSearchResult> getPopularMovies(
      {@http.Query("page") int page = 1,
      @http.Query('language') String language = 'en-US'});

  @http.GET("/movie/top_rated")
  @http.Headers(headerMap)
  Future<MovieSearchResult> getTopRatedMovies(
      {@http.Query("page") int page = 1,
      @http.Query('language') String language = 'en-US'});

  @http.GET("/movie/upcoming")
  @http.Headers(headerMap)
  Future<MovieSearchResult> getUpcomingMovies({
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en-US',
    @http.Query('region') String region = 'US',
  });

  /// https://api.themoviedb.org/3/discover/movie?
  /// api_key=ec7b57c566e8af94115bb2c0d910f610&language=en-US
  /// &sort_by=release_date.asc&page=1
  /// &release_date.gte=2023-01-17&release_date.lte=2023-02-16&region=US
  /// &with_original_language=en&with_release_type=3|2
  ///
  /// release_date.gte (tomorrow [Now + 1])
  /// release_date.lte (30 days from tomorrow [Now + 31])
  @http.GET("/discover/{media_type}")
  @http.Headers(headerMap)
  Future<MovieSearchResult> discoverUpcomingMovies(
    @http.Path("media_type") String mediaType,
    @http.Query('release_date.gte') String dateGte,
    @http.Query('release_date.lte') String dateLte, {
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en-US',
    @http.Query('region') String region = 'US',
    @http.Query('sort_by') String sortBy = 'popularity.desc',
    @http.Query('include_adult') String includeAdult = 'false',
    @http.Query('with_original_language') String originalLanguage = 'en',
    @http.Query('with_release_type') String releaseType = '3|2',
  });

  @http.GET("/trending/{media_type}/{time_window}")
  @http.Headers(headerMap)
  Future<MovieSearchResult> getTrending(
      @http.Path("media_type") String mediaType,
      @http.Path("time_window") String timeWindow,
      {@http.Query("page") int page = 1});

  @http.GET("/{media_type}/now_playing")
  @http.Headers(headerMap)
  Future<MovieSearchResult> getNowPlaying(
      @http.Path("media_type") String mediaType,
      {@http.Query("page") int page = 1,
      @http.Query('language') String language = 'en-US'});

  @http.GET("/discover/{media_type}")
  @http.Headers(headerMap)
  Future<MovieSearchResult> discoverMoviesByKeyword(
    @http.Path("media_type") String mediaType,
    @http.Query('with_keywords') String keywords,
    @http.Query('with_genres') String genres,
    /*@http.Query('release_date.gte') String dateGte,
    @http.Query('release_date.lte') String dateLte,*/
    {
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en-US',
    @http.Query('region') String region = 'US',
    @http.Query('sort_by') String sortBy = 'popularity.desc',
    @http.Query('include_adult') String includeAdult = 'false',
    @http.Query('with_original_language') String originalLanguage = 'en',
  });

  @http.GET("/discover/{media_type}")
  @http.Headers(headerMap)
  Future<MovieSearchResult> discoverMoviesByGenre(
    @http.Path("media_type") String mediaType,
    @http.Query('with_genres') String genres, {
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en-US',
    @http.Query('region') String region = 'US',
    @http.Query('sort_by') String sortBy = 'popularity.desc',
    @http.Query('include_adult') String includeAdult = 'false',
    @http.Query('with_original_language') String originalLanguage = 'en',
  });

  @http.GET("/{media_type}/{media_id}/recommendations")
  @http.Headers(headerMap)
  Future<MovieSearchResult> getRecommendations(
    @http.Path("media_type") String mediaType,
    @http.Path("media_id") int mediaId, {
    @http.Query("page") int page = 1,
    @http.Query('language') String language = 'en-US',
  });

  @http.GET("/person/{id}")
  @http.Headers(headerMap)
  Future<Person> getPersonWithDetail(
    @http.Path("id") int id, {
    @http.Query('append_to_response')
        String append = 'combined_credits,external_ids,images,tagged_images',
    @http.Query('language') String language = 'en-US',
  });

  // @http.GET("/person/{id}")
  // @http.Headers(headerMap)
  // Future<Person> getPersonWithCredits(
  //     @http.Path("id") int id, {
  //       @http.Query('append_to_response')
  //       String append = 'combined_credits',
  //       @http.Query('language') String language = 'en-US',
  //     });
}
